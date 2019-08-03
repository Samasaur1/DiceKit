import Danger
import Foundation
let danger = Danger()
let editedFiles = danger.git.modifiedFiles + danger.git.createdFiles

if danger.github.pullRequest.base.ref == "master" {
    let newVersion: String
    if let range = danger.github.pullRequest.title.range(of: #"(?<=Version )\d+\.\d+\.\d+(?=: .+)"#, options: .regularExpression) {
        newVersion = String(danger.github.pullRequest.title[range])
        message("The new version is v\(newVersion)")
    } else {
        fail("There is no version in the pull request title!")
        newVersion = "0.0.0"
    }

    if danger.github.pullRequest.title.contains("$DESCRIPTION") {
        fail("$DESCRIPTION placeholder has not been filled in!")
    }

    containsChangelog: if editedFiles.contains("CHANGELOG") {
        let lineNumber = danger.utils.lines(for: "## ", inFile: "CHANGELOG")[1]
        let line = danger.utils.readFile("CHANGELOG").split(separator: "\n").filter { $0.hasPrefix("## ") }[1]
        let dateString = String(line.drop { $0 != "]" }.dropFirst(4))
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let todaysDate = df.string(from: Date())
        guard df.date(from: dateString) != nil else {
            fail("Illegal date string in CHANGELOG!: '\(dateString)'")
            fail(message: "Illegal date string in CHANGELOG!", file: "CHANGELOG", line: lineNumber)
            suggestion(code: "## [\(newVersion)] - \(todaysDate)", file: "CHANGELOG", line: lineNumber)
            break containsChangelog
        }
        if todaysDate != dateString {
            fail("The latest date in the CHANGELOG is not today!")
            fail(message: "The latest date in the CHANGELOG is not today!", file: "CHANGELOG", line: lineNumber)
            suggestion(code: "## [\(newVersion)] - \(todaysDate)", file: "CHANGELOG", line: lineNumber)
        } else {
            message("The latest date in the CHANGELOG is today, \(dateString)")
        }
    } else {
        if FileManager.default.fileExists(atPath: "CHANGELOG") {
            fail("The CHANGELOG was not updated")
        } else {
            warn("There is no CHANGELOG!")
        }
    }
} else {
    if editedFiles.contains("CHANGELOG") {
        message("The CHANGELOG was updated!")
    } else {
        if FileManager.default.fileExists(atPath: "CHANGELOG") {
            fail("The CHANGELOG was not updated! (put your changes in the UPCOMING section)")
        } else {
            warn("There is no CHANGELOG!")
        }
    }
}

for file in editedFiles where file.hasPrefix("Sources/") {
    let dir = file.dropFirst("Sources/".count).split(separator: "/")[0]
    let fileName = file.dropFirst("Sources/\(dir)/".count).dropLast(".swift".count)
    let testsFile = "Tests/\(dir)Tests/\(fileName)Tests.swift"
    if editedFiles.contains(testsFile) {
        message("\(file) has had corresponding changes in its test file")
    } else {
        if FileManager.default.fileExists(atPath: testsFile) {
            fail("\(file) was changed, but \(testsFile) wasn't!")
        } else {
            warn("\(file) was changed, but there is no file at path \(testsFile). Maybe it's under a different path, or maybe there's no tests")
        }
    }
}

if danger.git.createdFiles.contains(where: { $0.hasPrefix("Tests/") }) {
    if editedFiles.contains("Tests/LinuxMain.swift") {
        message("LinuxMain was updated, but be sure it has ALL the tests")
    } else {
        fail("Tests were added, but LinuxMain wasn't updated! Run `swift test --generate-linuxmain` to update it")
    }
} else if editedFiles.contains(where: { $0.hasPrefix("Tests/") }) {
    if editedFiles.contains("Tests/LinuxMain.swift") {
        message("LinuxMain was updated, but be sure it has ALL the tests")
    } else {
        if editedFiles.contains(where: { (str: String) -> Bool in
            str.range(of: #"Tests/\w+/XCTestManifests\.swift"#, options: .regularExpression) != nil
        }) {
            fail("An XCTestManifests file was updated, but LinuxMain wasn't! run `swift test --generate-linuxmain` to update it")
            //This could happen if commas were changed, and then it shouldn't fail. Just add/delete a new line at the end of LinuxMain
        } else {
            warn("Test files were changed, but LinuxMain wasn't! This could be okay, if you just changed tests, but if you added any, run `swift test --generate-linuxmain` to update LinuxMain")
        }
    }
}
