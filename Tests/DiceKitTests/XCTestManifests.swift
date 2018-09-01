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
        ("testInitialization", testInitialization),
    ]
}

extension RollTests {
    static let __allTests = [
        ("testComparable", testComparable),
        ("testCompoundAssignmentOperators", testCompoundAssignmentOperators),
        ("testEquatable", testEquatable),
        ("testHashable", testHashable),
        ("testIntialization", testIntialization),
        ("testOperators", testOperators),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DiceKitTests.__allTests),
        testCase(DiceTests.__allTests),
        testCase(DieTests.__allTests),
        testCase(RollTests.__allTests),
    ]
}
#endif
