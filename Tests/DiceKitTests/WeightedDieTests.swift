import XCTest
@testable import DiceKit

final class WeightedDieTests: XCTestCase {
    func testInitialization() {
        let w = try? WeightedDie(chances: Chances(chances: [1: try! Chance.oneOut(of: 9)]))
        let w2 = try? WeightedDie(chances: Chances())
        XCTAssertNotNil(w)
        XCTAssertNil(w2)
    }
    
    func testCopying() {
        let firstDie = try! WeightedDie(chances: Chances(chances: [1: 1.0]))
        let secondDie = WeightedDie.init(copyOf: firstDie)
        let thirdDie = firstDie.copy()
        XCTAssertEqual(firstDie, secondDie)
        XCTAssertEqual(firstDie, thirdDie)
        XCTAssertEqual(secondDie, thirdDie)
    }
    
    func testRolling() {
        XCTFail("Not implemented")
    }
    
    func testEquatable() {
        let w = try! WeightedDie(chances: Chances(chances: [1: 1.0]))
        let w2 = try! WeightedDie(chances: Chances(chances: [1: 1.0]))
        let w3 = try! WeightedDie(chances: Chances(chances: [(1, 1.0)]))
        let w4 = try! WeightedDie(chances: Chances(chances: [2: 0.5]))
        
        XCTAssertEqual(w, w2)
        XCTAssertEqual(w, w3)
        XCTAssertEqual(w, w4)
        
        XCTAssertEqual(w2, w)
        XCTAssertEqual(w2, w3)
        XCTAssertEqual(w2, w4)
        
        XCTAssertEqual(w3, w)
        XCTAssertEqual(w3, w2)
        XCTAssertEqual(w3, w4)
        
        XCTAssertEqual(w4, w)
        XCTAssertEqual(w4, w2)
        XCTAssertEqual(w4, w3)
    }
    
    func testHashable() {
        #if swift(>=4.2)
        let w = try! WeightedDie(chances: Chances(chances: [1: 1.0]))
        let w2 = try! WeightedDie(chances: Chances(chances: [1: 1.0]))
        let w3 = try! WeightedDie(chances: Chances(chances: [(1, 1.0)]))
        let w4 = try! WeightedDie(chances: Chances(chances: [2: 0.5]))
        var h1 = Hasher()
        h1.combine(w)
        let hv1 = h1.finalize()
        var h2 = Hasher()
        h2.combine(w2)
        let hv2 = h2.finalize()
        var h3 = Hasher()
        h3.combine(w3)
        let hv3 = h3.finalize()
        var h4 = Hasher()
        h4.combine(w4)
        let hv4 = h4.finalize()
        XCTAssertEqual(hv1, hv2)
        XCTAssertEqual(hv1, hv3)
        XCTAssertEqual(hv2, hv3)
        XCTAssertNotEqual(hv1, hv4)
        XCTAssertNotEqual(hv2, hv4)
        XCTAssertEqual(hv3, hv4)
        #endif
    }
    
    func testSidesProperty() {
        let w = try! WeightedDie(chances: Chances(chances: [1: try! Chance.oneOut(of: 9)]))
        XCTAssertEqual(w.sides, 1)
        let chances = Chances(chances: [1: Chance.zero, 2: 0.1, 3: 0.5, 4: 0.5])
        let w2 = try! WeightedDie(chances: chances)
        XCTAssertEqual(w2.sides, 3) //sides with a chance of 0 don't exist.
    }
    
    func testChancesProperty() {
        let chances = Chances(chances: [1: try! Chance.oneOut(of: 9)])
        let w = try! WeightedDie(chances: chances)
        XCTAssertEqual(w.chances, chances.dict)
        let w2 = try! WeightedDie(chances: Chances(chances: [1: try! Chance(1, outOf: 9)]))
        XCTAssertEqual(w2.chances, chances.dict)
        XCTAssertEqual(w2.chances, w.chances)
    }
    
    func testMinimumResultProperty() {
        let w = try! WeightedDie(chances: Chances(chances: [1: 0.1, 5: 0.1, 9: 0.1]))
        XCTAssertEqual(w.minimumResult, 1)
        let w2 = try! WeightedDie(chances: Chances(chances: [1: 0.0, 5: 0.1, 9: 0.1]))
        XCTAssertEqual(w2.minimumResult, 5)
    }
    
    func testMaximumResultProperty() {
        let w = try! WeightedDie(chances: Chances(chances: [1: 0.1, 5: 0.1, 9: 0.1]))
        XCTAssertEqual(w.maximumResult, 9)
        let w2 = try! WeightedDie(chances: Chances(chances: [1: 0.1, 5: 0.1, 9: 0.0]))
        XCTAssertEqual(w2.maximumResult, 5)
    }
    
    func testDoubleAverageResultProperty() {
        XCTFail("Not implemented")
    }
    
    func testAverageResultProperty() {
        XCTFail("Not implemented")
    }
    
    func testCanReachProperty() {
        let w = try! WeightedDie(chances: Chances(chances: [1: 0.1, 5: 0.1, 9: 0.1]))
        #if swift(>=4.2)
        for type in RollComparison.allCases {
            XCTAssertTrue(w.canReach(1, type))
        }
        #else
        for type in [RollComparison.orLower, RollComparison.exactly, RollComparison.orHigher] {
            XCTAssertTrue(w.canReach(1, type))
        }
        #endif
        XCTAssertTrue(w.canReach(2, .orHigher))
        XCTAssertTrue(w.canReach(2, .orLower))
        XCTAssertFalse(w.canReach(2, .exactly))
        
        XCTAssertTrue(w.canReach(0, .orHigher))
        XCTAssertFalse(w.canReach(0, .orLower))
        XCTAssertFalse(w.canReach(0, .exactly))
    }
}
