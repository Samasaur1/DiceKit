import XCTest

extension DiceKitTests {
    static let __allTests = [
        ("testExample", testExample),
    ]
}

extension DiceTests {
    static let __allTests = [
        ("testExample", testExample),
    ]
}

extension DieTests {
    static let __allTests = [
        ("testCopying", testCopying),
        ("testEquatable", testEquatable),
        ("testInitialization", testInitialization),
        ("testMaximumResultProperty", testMaximumResultProperty),
        ("testMinimumResultProperty", testMinimumResultProperty),
        ("testRolling", testRolling),
        ("testSidesProperty", testSidesProperty),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DiceKitTests.__allTests),
        testCase(DiceTests.__allTests),
        testCase(DieTests.__allTests),
    ]
}
#endif
