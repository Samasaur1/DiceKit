import XCTest
@testable import DiceKit

final class ChancesTests: XCTestCase {
    func testInitialization() {
        let _ = Chances(chances: [1: 0.1])
        let _ = Chances(chances: [:])
        let _ = Chances(chances: [(1, 0.1)])
        let _ = Chances(chances: [])
        let _ = Chances()
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
        
        XCTAssertEqual(c, c2)
        XCTAssertEqual(c, c3)
        XCTAssertEqual(c2, c3)
    }
    
    func testSubscript() {
        var c = Chances()
        XCTAssertEqual(c[of: 5], 0.0)
        c[of: 5] = 0.4
        XCTAssertEqual(c[of: 5], 0.4)
    }
}
