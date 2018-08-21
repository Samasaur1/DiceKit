import XCTest
@testable import DiceKit

final class DiceKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(DiceKit().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
