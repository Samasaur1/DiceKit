import Danger
import Foundation
let danger = Danger()
let editedFiles = danger.git.modifiedFiles + danger.git.createdFiles

// MARK: - New Version PR
if let range = danger.github.pullRequest.title.range(of: #"(?<=Version )\d+\.\d+\.\d+(?=: .+)"#, options: .regularExpression) {
    if danger.github.pullRequest.base.ref != "master" {
        fail("PRs to non-`master` branches should not have \"Version X.Y.Z\" in the PR title")
    } else {
        message("Pull request to `master` for new version detected")
    }
    // MARK: New version (PR title)
    let newVersion = String(danger.github.pullRequest.title[range])
    message("The new version is v\(newVersion)")
    // MARK: New version (.jazzy.yaml)
    let jazzyVersion = String(danger.utils.readFile(".jazzy.yaml").split(separator: "\n")[4].dropFirst(16))
    if editedFiles.contains(".jazzy.yaml") {
        message(".jazzy.yaml was updated")
    } else {
        fail("Version was not updated in .jazzy.yaml!")
        fail(message: "Version was not updated in .jazzy.yaml!", file: ".jazzy.yaml", line: 5)
        suggestion(code: "module_version: \(newVersion)", file: ".jazzy.yaml", line: 5)
    }
    if newVersion == jazzyVersion {
        message("PR title and .jazzy.yaml agree")
    } else {
        fail("PR title specifies version \(newVersion), while .jazzy.yaml specifies \(jazzyVersion)")
        suggestion(code: "module_version: \(newVersion)", file: ".jazzy.yaml", line: 5)
    }

    // MARK: Changelog entry
    if let lineNumber = danger.utils.lines(for: "## [\(newVersion)]", inFile: "CHANGELOG.md").first, let line = danger.utils.readFile("CHANGELOG.md").split(separator: "\n").first(where: { $0.hasPrefix("## [\(newVersion)]") }) {
        message("There is a CHANGELOG entry for this version")
        let dateString = String(line.dropFirst("## [\(newVersion)] - ".count))
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        if df.string(from: Date()) == dateString {
            message("The date for this version's entry is today, \(dateString)")
        } else {
            fail("The date for this version's entry is not today!")
            fail(message: "The date for this version's entry is not today!", file: "CHANGELOG.md", line: lineNumber)
            suggestion(code: "## [\(newVersion)] — \(df.string(from: Date()))", file: "CHANGELOG.md", line: lineNumber)
        }
        // MARK: Changelog compare link
        if let upcomingLineNumber = danger.utils.lines(for: "[Upcoming]:", inFile: "CHANGELOG.md").first,
           let upcomingLine = danger.utils.readFile("CHANGELOG.md").split(separator: "\n").first(where: { $0.hasPrefix("[Upcoming]:") }) {
            if upcomingLine == "[Upcoming]: https://github.com/Samasaur1/DiceKit/compare/v\(newVersion)...master" {
                message("Upcoming link was updated to show changes between latest version and `master`")
            } else {
                fail("Upcoming link was not updated to show the latest changes")
                suggestion(code: "[Upcoming]: https://github.com/Samasaur1/DiceKit/compare/v\(newVersion)...master", file: "CHANGELOG.md", line: upcomingLineNumber)
            }
        } else {
            fail("The upcoming changes compare link line is missing!")
        }
        if let linkLineNumber = danger.utils.lines(for: "[\(newVersion)]:", inFile: "CHANGELOG.md").first,
           let linkLine = danger.utils.readFile("CHANGELOG.md").split(separator: "\n").first(where: { $0.hasPrefix("[\(newVersion)]:") }) {
            if linkLine.hasSuffix("...v\(newVersion)") {
                message("Link line compares to the new version")
            } else {
                fail(message: "Link line does not compare to the new version, v\(newVersion)", file: "CHANGELOG.md", line: linkLineNumber)
            }
        } else {
            fail("There is no link line to compare the new version to the previous version!")
        }
    } else {
        fail("There is no CHANGELOG entry for this version!")
    }
} else { // MARK: - Non-new version PR
    message("Non-new version PR detected, to branch \(danger.github.pullRequest.base.ref)")
    if danger.github.pullRequest.base.ref != "master" {
        warn("Most PRs should be made directly to `master`. If you know why you're making it to a different branch, ignore this warning.")
    }
    if danger.github.pullRequest.head.repo.fullName == "Samasaur1/DiceKit" {
        message("Internal PR detected")
    } else {
        message("PR from fork detected — thanks for contributing!")
    }
}

// MARK: - All PRs

// MARK: Changelog updated
if editedFiles.contains("CHANGELOG.md") {
    message("The CHANGELOG was updated")
} else {
    if FileManager.default.fileExists(atPath: "CHANGELOG.md") {
        fail("The CHANGELOG was not updated! (put your changes in the UPCOMING section)")
    } else {
        warn("There is no CHANGELOG!")
    }
}

// MARK: Updated tests
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

// MARK: Updated test manifests
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

// MARK: Tasks in PR body
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
        for (num, line) in allTaskLines.enumerated()/*.reversed()*/ {
            if line.range(of: #"^- \[x\] "#, options: .regularExpression) != nil {
                message("**Task \(num + 1) completed:** \(line.dropFirst(6))")
                continue
            }
            fail("**Task \(num + 1) incomplete:** \(line.dropFirst(6))")  // "- [ ] "
        }
    } else {
        warn("PR has no tasks (are you sure?)")
    }
} else {
    warn("Cannot fetch PR body!")
}
