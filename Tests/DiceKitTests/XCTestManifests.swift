import XCTest

extension DiceKitTests {
    static let __allTests = [
        ("testExample", testExample),
    ]
}

extension RollTests {
    static let __allTests = [
        ("testExample", testExample),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DiceKitTests.__allTests),
        testCase(RollTests.__allTests),
    ]
}
#endif
