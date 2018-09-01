import XCTest
@testable import DiceKit

final class DieTests: XCTestCase {
    func testInitialization() {
        let negativeOneDie = Die(sides: -1)
        let zeroDie = Die(sides: 0)
        let d6 = Die(sides: 6)
        XCTAssertNil(negativeOneDie)
        XCTAssertNil(zeroDie)
        XCTAssertNotNil(d6)
    }
}
