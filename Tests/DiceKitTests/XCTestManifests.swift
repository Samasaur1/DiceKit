import XCTest

extension DiceKitTests {
    static let __allTests = [
        ("testDieToDiceOperators", testDieToDiceOperators),
    ]
}

extension DiceTests {
    static let __allTests = [
        ("testEmptyStringParsing", testEmptyStringParsing),
        ("testInvalidStringParsing", testInvalidStringParsing),
        ("testMultipleDieAndMultipleModifierStringParsing", testMultipleDieAndMultipleModifierStringParsing),
        ("testMultipleModifierStringParsing", testMultipleModifierStringParsing),
        ("testMultipleRepeatedDieStringParsing", testMultipleRepeatedDieStringParsing),
        ("testMultipleSeparateDieStringParsing", testMultipleSeparateDieStringParsing),
        ("testSingleDieAndSingleModifierStringParsing", testSingleDieAndSingleModifierStringParsing),
        ("testSingleDieStringParsing", testSingleDieStringParsing),
        ("testSingleModifierStringParsing", testSingleModifierStringParsing),
    ]
}

extension DieTests {
    static let __allTests = [
        ("testComparable", testComparable),
        ("testCopying", testCopying),
        ("testEquatable", testEquatable),
        ("testInitialization", testInitialization),
        ("testInvalidStringParsing", testInvalidStringParsing),
        ("testMaximumResultProperty", testMaximumResultProperty),
        ("testMinimumResultProperty", testMinimumResultProperty),
        ("testMultipleDigitStringParsing", testMultipleDigitStringParsing),
        ("testRolling", testRolling),
        ("testSidesProperty", testSidesProperty),
        ("testSingleDigitStringParsing", testSingleDigitStringParsing),
        ("testStaticVarDice", testStaticVarDice),
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
