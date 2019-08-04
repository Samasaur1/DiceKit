@testable import DiceKit
import XCTest

final class WeightedDieTests: XCTestCase {
    func testInitialization() {
        let w = try? WeightedDie(chances: Chances(chances: [1: try! Chance.oneOut(of: 9)]))
        let w2 = try? WeightedDie(chances: Chances())
        XCTAssertNotNil(w)
        XCTAssertNil(w2)
        
        XCTAssertNoThrow(try WeightedDie(chances: Chances(chances: [1: try! Chance.oneOut(of: 9)])))
        XCTAssertThrowsError(try WeightedDie(chances: Chances()))
    }

    func testCopying() {
        let firstDie = try! WeightedDie(chances: Chances(chances: [1: 1.0]))
        let secondDie = WeightedDie(copyOf: firstDie)
        let thirdDie = firstDie.copy()
        XCTAssertAllEqual(firstDie, secondDie, thirdDie)
    }

    func testRolling() {
        let _100percent = try! WeightedDie(chances: Chances(chances: [1: .one, 2: .zero]))
        for _ in 0..<1_000 {
            if _100percent.roll() != 1 {
                XCTFail()
            }
        }
        XCTAssertEqual(_100percent.roll(times: 1_000, .sum), 1_000, "The sum of 1000 rolls wasn't 1000 (i.e. some roll wasn't 1")

        let _100percent2 = try! WeightedDie(chances: Chances(chances: [3: .oneOut(of: 10), 4: .zero]))
        for _ in 0..<1_000 {
            if _100percent2.roll() != 3 {
                XCTFail()
            }
        }
        XCTAssertEqual(_100percent2.roll(times: 1_000, .sum), 3_000, "The sum of 1000 rolls wasn't 3000 (i.e. some roll wasn't 3")

        let equalChances = try! WeightedDie(chances: Chances(chances: [5: .oneOut(of: 2), 6: .oneOut(of: 2)]))
        var fives = 0
        for _ in 0..<100_000 {
            let r = equalChances.roll()
            if r == 5 { fives += 1 }
        }
        XCTAssertTrue(abs(50_000 - fives) < 10_000, "\(abs(50_000 - fives))")
        XCTAssertTrue(abs(550_000 - equalChances.roll(times: 100_000, .sum)) < 1_000)

        let equalChances2 = try! WeightedDie(chances: Chances(chances: [7: .oneOut(of: 6), 8: .oneOut(of: 6)]))
        var sevens = 0
        for _ in 0..<100_000 {
            let r = equalChances2.roll()
            if r == 7 { sevens += 1 }
        }
        XCTAssertTrue(abs(50_000 - sevens) < 10_000, "\(abs(50_000 - sevens))")
        XCTAssertTrue(abs(750_000 - equalChances2.roll(times: 100_000, .sum)) < 1_000)

        let w = try! WeightedDie(chances: Chances(chances: [9: .init(1, outOf: 10), 10: .init(3, outOf: 10)]))
        var nines = 0
        for _ in 0..<100_000 {
            let r = w.roll()
            if r == 9 { nines += 1 }
        }
        XCTAssertTrue(abs(25_000 - nines) < 10_000, "\(abs(25_000 - nines))")
    }

    func testEquatable() {
        let w = try! WeightedDie(chances: Chances(chances: [1: 1.0]))
        let w2 = try! WeightedDie(chances: Chances(chances: [1: 1.0]))
        let w3 = try! WeightedDie(chances: Chances(chances: [(1, 1.0)]))
        let w4 = try! WeightedDie(chances: Chances(chances: [2: 0.5]))

        XCTAssertEqual(w, w2)
        XCTAssertEqual(w, w3)
        XCTAssertNotEqual(w, w4)

        XCTAssertEqual(w2, w)
        XCTAssertEqual(w2, w3)
        XCTAssertNotEqual(w2, w4)

        XCTAssertEqual(w3, w)
        XCTAssertEqual(w3, w2)
        XCTAssertNotEqual(w3, w4)

        XCTAssertNotEqual(w4, w)
        XCTAssertNotEqual(w4, w2)
        XCTAssertNotEqual(w4, w3)
    }

    func testHashable() {
        let w = try! WeightedDie(chances: Chances(chances: [1: 1.0]))
        let w2 = try! WeightedDie(chances: Chances(chances: [1: 1.0]))
        let w3 = try! WeightedDie(chances: Chances(chances: [(1, 1.0)]))
        let w4 = try! WeightedDie(chances: Chances(chances: [2: 0.5]))
        let hv1 = w.hashValue //hashValue is now a computed property, don't worry
        let hv2 = w2.hashValue
        let hv3 = w3.hashValue
        let hv4 = w4.hashValue
        XCTAssertEqual(hv1, hv2)
        XCTAssertEqual(hv1, hv3)
        XCTAssertNotEqual(hv1, hv4)
        XCTAssertEqual(hv2, hv3)
        XCTAssertNotEqual(hv2, hv4)
        XCTAssertNotEqual(hv3, hv4)
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
        XCTAssertEqual(w.chances, chances.normalized.dict)
        let w2 = try! WeightedDie(chances: Chances(chances: [1: try! Chance(1, outOf: 9)]))
        XCTAssertEqual(w2.chances, chances.normalized.dict)
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
        #warning("WeightedDieTests.testDoubleAverageResultProperty not implemented")
    }

    func testAverageResultProperty() {
        #warning("WeightedDieTests.testAverageResultProperty not implemented")
    }

    func testCanReachProperty() {
        let w = try! WeightedDie(chances: Chances(chances: [1: 0.1, 5: 0.1, 9: 0.1]))
        for type in RollComparison.allCases {
            XCTAssertTrue(w.canReach(1, type))
        }
        XCTAssertTrue(w.canReach(2, .orHigher))
        XCTAssertTrue(w.canReach(2, .orLower))
        XCTAssertFalse(w.canReach(2, .exactly))

        XCTAssertTrue(w.canReach(0, .orHigher))
        XCTAssertFalse(w.canReach(0, .orLower))
        XCTAssertFalse(w.canReach(0, .exactly))
    }

    func testChance() {
        let w = try! WeightedDie(chances: Chances(chances: (1, 0.25), (2, 0.05), (3, 0.05), (4, 0.05), (5, 0.1), (6, 0.5)))

        let chance = w.chance(of: 4, .exactly)
        XCTAssertEqual(chance, 0.05)

        let chance2 = w.chance(of: 7, .orHigher)
        XCTAssertEqual(chance2, Chance.zero)

        let chance3 = w.chance(of: 5, .orLower)
        XCTAssertEqual(chance3, 0.5)
    }
    
    func testRollingMultipleTimes() {
        #warning("WeightedDieTests.testRollingMultipleTimes not implemented")
    }
    
    func testChanceInRange() {
        let chances = Chances(chances: [1: try! .oneOut(of: 5), 2: .zero, 3: .zero, 4: try! .init(oneOutOf: 10), 5: .zero, 6: try! .init(7, outOf: 10)])
        let w = try! WeightedDie(chances: chances)
        
        XCTAssertEqual(w.chance(of: 1...6), .one)
        XCTAssertEqual(w.chance(of: 1..<6), try! .init(3, outOf: 10))
        XCTAssertEqual(w.chance(of: 2..<4), .zero)
        XCTAssertEqual(w.chance(of: 2...5), try! .init(oneOutOf: 10))
        
        XCTAssertEqual(w.chance(of: 5...), try! .init(7, outOf: 10))
        XCTAssertEqual(w.chance(of: ...1), try! .oneOut(of: 5))
        XCTAssertEqual(w.chance(of: ..<1), .zero)
    }
    
    func testProbabilities() {
        let chances = Chances(chances: [1: try! Chance.oneOut(of: 9), 2: .zero])
        let w = try! WeightedDie(chances: chances)
        
        XCTAssertEqual(w.probabilities, chances.normalized)
        XCTAssertEqual(w.probabilities[of: 1], .one)
        XCTAssertEqual(w.probabilities[of: 2], .zero)
        XCTAssertEqual(w.probabilities[of: 3], .zero)
        
        let c2 = Chances(chances: [1: try! Chance.oneOut(of: 9), 2: try! .init(3, outOf: 9)])
        let w2 = try! WeightedDie(chances: c2)
        
        XCTAssertEqual(w2.probabilities, c2.normalized)
        XCTAssertEqual(w2.probabilities[of: 1], try! .init(1, outOf: 4))
        XCTAssertEqual(w2.probabilities[of: 2], try! .init(3, outOf: 4))
        XCTAssertEqual(w2.probabilities[of: 3], .zero)
    }
}
