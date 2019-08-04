@testable import DiceKit
import XCTest

final class ChancesTests: XCTestCase {
    func testInitialization() {
        _ = Chances(chances: [1: 0.1])
        _ = Chances(chances: [:])
        _ = Chances(chances: [(1, 0.1)])
        _ = Chances(chances: [])
        _ = Chances()
    }

    func testDictionaryProperty() {
        let dict: [Roll: Chance] = [5: 0.234, 8: 0.432]
        let c = Chances(chances: dict)
        XCTAssertEqual(dict, c.dict)
    }

    func testEquatable() {
        let c = Chances(chances: [:])
        let c2 = Chances(chances: [])
        let c3 = Chances()

        XCTAssertAllEqual(c, c2, c3)
    }

    func testSubscript() {
        var c = Chances()
        XCTAssertEqual(c[of: 5], 0.0)
        c[of: 5] = 0.4
        XCTAssertEqual(c[of: 5], 0.4)
    }

    func testHashable() {
        let c = Chances(chances: [:]).hashValue
        let c2 = Chances(chances: []).hashValue
        let c3 = Chances().hashValue

        XCTAssertAllEqual(c, c2, c3)
    }
}
