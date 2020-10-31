import Danger
import Foundation
let danger = Danger()
let editedFiles = danger.git.modifiedFiles + danger.git.createdFiles

// MARK: - PR to master
if danger.github.pullRequest.base.ref == "master" {
    // MARK: New version (PR title)
    let newVersion: String
    if let range = danger.github.pullRequest.title.range(of: #"(?<=Version )\d+\.\d+\.\d+(?=: .+)"#, options: .regularExpression) {
        newVersion = String(danger.github.pullRequest.title[range])
        message("The new version is v\(newVersion)")
    } else {
        fail("There is no version in the pull request title!")
        newVersion = "0.0.0"
    }
    // MARK: New version (.jazzy.yaml)
    let jazzyVersion = String(danger.utils.readFile(".jazzy.yaml").split(separator: "\n")[4].dropFirst(17))
    let jazzyVersionUpdated: Bool
    if editedFiles.contains(".jazzy.yaml") {
        jazzyVersionUpdated = true
    } else {
        fail("Version was not updated in .jazzy.yaml!")
        fail(message: "Version was not updated in .jazzy.yaml!", file: ".jazzy.yaml", line: 5)
        jazzyVersionUpdated = false
    }
    switch (newVersion, jazzyVersionUpdated) {
    case ("0.0.0", false):
        fail("No new version was indicated!")
    case ("0.0.0", true):
        message("PR title should be amended to \"Version \(jazzyVersion): \(danger.github.pullRequest.title)\"")
    case (_, false):
        suggestion(code: "module_version: \(newVersion)", file: ".jazzy.yaml", line: 5)
    case (_, true):
        message("Version was updated in both locations!")
    }

    if danger.github.pullRequest.title.contains("$DESCRIPTION") {
        fail("$DESCRIPTION placeholder has not been filled in!")
    }

    if danger.github.pullRequest.body?.split(separator: "\n").suffix(3).map(String.init) != ["1. Wait for CI", "1. Merge", "1. Run `release.sh`"] {
        warn("Remember to run `release.sh` after merging!")
    }

    // MARK: Changelog edited
    containsChangelog: if editedFiles.contains("CHANGELOG.md") {
        let lineNumber = danger.utils.lines(for: "## ", inFile: "CHANGELOG.md")[1]
        let line = danger.utils.readFile("CHANGELOG.md").split(separator: "\n").filter { $0.hasPrefix("## ") }[1]
        let dateString = String(line.drop { $0 != "]" }.dropFirst(4))
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let todaysDate = df.string(from: Date())
        guard df.date(from: dateString) != nil else {
            fail("Illegal date string in CHANGELOG!: '\(dateString)'")
            fail(message: "Illegal date string in CHANGELOG!", file: "CHANGELOG.md", line: lineNumber)
            suggestion(code: "## [\(newVersion)] - \(todaysDate)", file: "CHANGELOG.md", line: lineNumber)
            break containsChangelog
        }
        if todaysDate != dateString {
            fail("The latest date in the CHANGELOG is not today!")
            fail(message: "The latest date in the CHANGELOG is not today!", file: "CHANGELOG.md", line: lineNumber)
            suggestion(code: "## [\(newVersion)] - \(todaysDate)", file: "CHANGELOG.md", line: lineNumber)
        } else {
            message("The latest date in the CHANGELOG is today, \(dateString)")
        }
    } else {
        if FileManager.default.fileExists(atPath: "CHANGELOG.md") {
            fail("The CHANGELOG was not updated")
        } else {
            warn("There is no CHANGELOG!")
        }
    }
} else {
    if editedFiles.contains("CHANGELOG.md") {
        message("The CHANGELOG was updated!")
    } else {
        if FileManager.default.fileExists(atPath: "CHANGELOG.md") {
            fail("The CHANGELOG was not updated! (put your changes in the UPCOMING section)")
        } else {
            warn("There is no CHANGELOG!")
        }
    }
}

// MARK: - Updated tests
// Make sure source changes have their tests updated
for file in editedFiles where file.hasPrefix("Sources/") {
    let dir = file.dropFirst("Sources/".count).split(separator: "/")[0]
    let fileName = file.dropFirst("Sources/\(dir)/".count).dropLast(".swift".count)
    let testsFile = "Tests/\(dir)Tests/\(fileName)Tests.swift"
    if editedFiles.contains(testsFile) {
        message("\(file) has had corresponding changes in its test file")
    } else {
        if FileManager.default.fileExists(atPath: testsFile) {
            warn("\(file) was changed, but \(testsFile) wasn't! You should probably test the new behavior")
        } else {
            warn("\(file) was changed, but there is no file at path \(testsFile). Maybe it's under a different path, or maybe there are no tests")
        }
    }
}

// MARK: - Updated test manifests
// If tests are added, ensure that they're in XCTestManifest / LinuxMain
if danger.git.createdFiles.contains(where: { $0.hasPrefix("Tests/") }) {
    // LinuxMain doesn't need to change anymore, unless a new XCTestManifests file is added
    if danger.git.createdFiles.contains(where: { (str: String) -> Bool in
        str.range(of: #"Tests/\w+/XCTestManifests\.swift"#, options: .regularExpression) != nil
    }) {
        if editedFiles.contains("Tests/LinuxMain.swift") {
            message("LinuxMain was updated to include the new XCTestManifests file(s), but be sure it has ALL of them")
        } else {
            fail("A new XCTestManifests file was added, but LinuxMain wasn't updated! Run `swift test --generate-linuxmain` to update it")
        }
    } else if editedFiles.contains(where: { (str: String) -> Bool in
        str.range(of: #"Tests/\w+/XCTestManifests\.swift"#, options: .regularExpression) != nil
    }) {
        message("An XCTestManifests file was updated, but make sure it has ALL the new tests")
    } else {
        fail("A new test file was added, but no manifest files were updated/created. Run `swift test --generate-linuxmain` to do so")
    }
} else if editedFiles.contains(where: { $0.hasPrefix("Tests/") }) {
    if editedFiles.contains(where: { (str: String) -> Bool in
        str.range(of: #"Tests/\w+/XCTestManifests\.swift"#, options: .regularExpression) != nil
    }) {
        message("An XCTestManifests file was updated, but be sure it has ALL the new tests!")
    } else {
        warn("Test files were changed, but no XCTestManifests were. This could be okay, if you just changed tests, but if you added any, run `swift test --generate-linuxmain` to update the manifests")
    }
}

// MARK: - Tasks in PR body
// Check for incomplete tasks in the PR body
// Note the difference between the first regex and the later two ("\n" vs "^").
//   That's the "start of string" character, which I only want to match after I've split
//   on "\n". Therefore, this only matches lines that start with a task,
//   which excludes nested tasks.
if let body = danger.github.pullRequest.body {
    if body.range(of: #"\n- \[[x ]\] "#, options: .regularExpression) != nil {
        let split = body.split { $0.isNewline }
        let allTaskLines = split
            .filter { $0.range(of: #"^- \[[x ]\] "#, options: .regularExpression) != nil }
        for (num, line) in allTaskLines.enumerated().reversed() {
            if line.range(of: #"^- \[x\] "#, options: .regularExpression) != nil {
                message("**Task \(num + 1) completed:** \(line.dropFirst(6))")
                continue
            }
            fail("**Task \(num + 1) incomplete:** \(line.dropFirst(6))")  // "- [ ] "
        }
    } else {
        warn("PR body doesn't appear to have any tasks, which it should")
    }
} else {
    warn("Cannot fetch PR body!")
}
