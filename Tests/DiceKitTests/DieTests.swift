@testable import DiceKit
import XCTest

final class DieTests: XCTestCase {
    func testInitialization() {
        let negativeOneDie = try? Die(sides: -1)
        let zeroDie = try? Die(sides: 0)
        let d6 = try? Die(sides: 6)
        XCTAssertNil(negativeOneDie)
        XCTAssertNil(zeroDie)
        XCTAssertNotNil(d6)
    }

    func testSingleDigitStringParsing() {
        let d6_1 = try? Die("6")
        let d6_2 = try? Die("d6")
        let d6_3 = try? Die("D6")

        XCTAssertNotNil(d6_1)
        XCTAssertNotNil(d6_2)
        XCTAssertNotNil(d6_3)

        XCTAssertEqual(d6_1, Die.d6)
        XCTAssertEqual(d6_2, Die.d6)
        XCTAssertEqual(d6_3, Die.d6)
    }

    func testMultipleDigitStringParsing() {
        let d12_1 = try? Die("12")
        let d12_2 = try? Die("d12")
        let d12_3 = try? Die("D12")

        XCTAssertNotNil(d12_1)
        XCTAssertNotNil(d12_2)
        XCTAssertNotNil(d12_3)

        XCTAssertEqual(d12_1, Die.d12)
        XCTAssertEqual(d12_2, Die.d12)
        XCTAssertEqual(d12_3, Die.d12)
    }

    func testInvalidStringParsing() {
        // Assorted
        XCTAssertNil(try? Die("")) // empty
        XCTAssertNil(try? Die("d")) // d without value
        XCTAssertNil(try? Die("q1")) // other than d in front
        XCTAssertNil(try? Die("d1b")) // binary (other form with d)
        XCTAssertNil(try? Die("1o")) // octal (other form without d)
        XCTAssertNil(try? Die("one")) // spelled out
        XCTAssertNil(try? Die("A")) // hexadecimal
        XCTAssertNil(try? Die("DiceKit")) // string

        //Negative
        XCTAssertNil(try? Die("-6"))
        XCTAssertNil(try? Die("-d6"))
        XCTAssertNil(try? Die("d-6"))

        //Positive
        XCTAssertNil(try? Die("+6"))
        XCTAssertNil(try? Die("+d6"))
        XCTAssertNil(try? Die("d+6"))
    }

    func testSidesProperty() {
        for i in 1...100 {
            let die = try! Die(sides: i)
            XCTAssertEqual(die.sides, i)
        }
    }

    func testCopying() {
        let firstDie = Die.d6
        let secondDie = Die(copyOf: firstDie)
        let thirdDie = firstDie.copy()
        XCTAssertEqual(firstDie, secondDie)
        XCTAssertEqual(firstDie, thirdDie)
        XCTAssertEqual(secondDie, thirdDie)
    }

    func testRolling() {
        let die = Die.d6
        var rolled = [true, false, false, false, false, false, false]
        while rolled.contains(false) {
            let r = die.roll()
            XCTAssertGreaterThanOrEqual(r, 1)
            XCTAssertLessThanOrEqual(r, 6) //If the die is changed away from a d6, change this
            rolled[r] = true
        }
    }

    func testMinimumResultProperty() {
        for i in 1...25 {
            let d = try! Die(sides: i)
            XCTAssertEqual(d.minimumResult, 1)
        }
    }

    func testMaximumResultProperty() {
        for i in 1...25 {
            let d = try! Die(sides: i)
            XCTAssertEqual(d.maximumResult, d.sides)
        }
    }

    func testCanReach() {
        let d6 = Die.d6

        for target in 1...6 {
            for type in RollComparison.allCases {
                XCTAssertTrue(d6.canReach(target, type))
            }
        }

        XCTAssertTrue(d6.canReach(8, .orLower))
        XCTAssertFalse(d6.canReach(8, .exactly))
        XCTAssertFalse(d6.canReach(8, .orHigher))
    }

    func testAverageResultProperty() {
        XCTAssertEqual(Die.d6.averageResult, 4)

        for _ in 1...5 {
            let r = Int.random(in: 1...10_000)
            guard let d = try? Die(sides: r) else {
                XCTFail()
                continue
            }
            XCTAssertEqual(d.averageResult, Int((Double(r + 1) / 2).rounded()))
        }
    }

    func testDoubleAverageResultProperty() {
        XCTAssertEqual(Die.d6.doubleAverageResult, 3.5)

        for _ in 1...5 {
            let r = Int.random(in: 1...10_000)
            guard let d = try? Die(sides: r) else {
                XCTFail()
                continue
            }
            XCTAssertEqual(d.doubleAverageResult, Double(r + 1) / 2)
        }
    }

    func testMinAverageMax() {
        for _ in 1...10 {
            let optionalDie = try? Die(sides: Int.random(in: 1...1_000_000))
            guard let d = optionalDie else {
                XCTFail()
                continue
            }
            XCTAssertLessThanOrEqual(d.minimumResult, d.averageResult)
            XCTAssertLessThanOrEqual(d.averageResult, d.maximumResult)
        }
    }

    func testEquatable() {
        let d6 = Die.d6
        let initializedD6 = try! Die(sides: 6)
        let copiedD6 = Die.d6.copy()
        let initializedWithCopyD6 = Die(copyOf: Die.d6)
        let d4 = Die.d4
        XCTAssertEqual(d6, initializedD6)
        XCTAssertEqual(d6, copiedD6)
        XCTAssertEqual(d6, initializedWithCopyD6)
        XCTAssertNotEqual(d6, d4)

        XCTAssertEqual(initializedD6, d6)
        XCTAssertEqual(initializedD6, copiedD6)
        XCTAssertEqual(initializedD6, initializedWithCopyD6)
        XCTAssertNotEqual(initializedD6, d4)

        XCTAssertEqual(copiedD6, d6)
        XCTAssertEqual(copiedD6, initializedD6)
        XCTAssertEqual(copiedD6, initializedWithCopyD6)
        XCTAssertNotEqual(copiedD6, d4)

        XCTAssertEqual(initializedWithCopyD6, d6)
        XCTAssertEqual(initializedWithCopyD6, initializedD6)
        XCTAssertEqual(initializedWithCopyD6, copiedD6)
        XCTAssertNotEqual(initializedWithCopyD6, d4)
    }

    func testComparable() {
        let d6 = Die.d6
        let d6_2 = Die.d6
        let d4 = Die.d4

        XCTAssertGreaterThan(d6, d4)
        XCTAssertGreaterThanOrEqual(d6, d6_2)
        XCTAssertLessThan(d4, d6)
        XCTAssertLessThanOrEqual(d6, d6_2)
    }

    func testStaticVarDice() {
        XCTAssertEqual(Die.d4, try! Die(sides: 4))
        XCTAssertEqual(Die.d6, try! Die(sides: 6))
        XCTAssertEqual(Die.d8, try! Die(sides: 8))
        XCTAssertEqual(Die.d10, try! Die(sides: 10))
        XCTAssertEqual(Die.d12, try! Die(sides: 12))
        XCTAssertEqual(Die.d20, try! Die(sides: 20))
        XCTAssertEqual(Die.d100, try! Die(sides: 100))
    }

    func testChance() {
        let d = Die.d6

        let chance = d.chance(of: 4, .exactly)
        XCTAssertEqual(chance, try! Chance(oneOutOf: 6))

        let chance2 = d.chance(of: 7, .orHigher)
        XCTAssertEqual(chance2, Chance.zero)

        let chance3 = d.chance(of: 5, .orLower)
        XCTAssertEqual(chance3, try! Chance(5, outOf: 6))
    }
    
    func testRollingMultipleTimes() {
        let die = Die.d6
        var rolled = [Bool].init(repeating: false, count: 13)
        rolled[0] = true
        rolled[1] = true//0 and 1 can't be rolled
        while rolled.contains(false) {
            let r = die.roll(times: 2, .sum)
            XCTAssertGreaterThanOrEqual(r, 2)
            XCTAssertLessThanOrEqual(r, 12) //If the die is changed away from a d6, change this
            rolled[r] = true
        }
    }
    
    func testChanceInRange() {
        let d6 = Die.d6
        XCTAssertEqual(d6.chance(of: 1...6), .one)
        XCTAssertEqual(d6.chance(of: 2...4), try! .init(1, outOf: 2))
        XCTAssertEqual(d6.chance(of: 7...26), .zero)
        
        XCTAssertEqual(d6.chance(of: -5..<10), .one)
        XCTAssertEqual(d6.chance(of: 2..<4), try! .init(1, outOf: 3))
        XCTAssertEqual(d6.chance(of: 7..<26), .zero)
        
        XCTAssertEqual(d6.chance(of: 1...), .one)
        XCTAssertEqual(d6.chance(of: 6...), try! .init(1, outOf: 6))
        XCTAssertEqual(d6.chance(of: 7...), .zero)
        
        XCTAssertEqual(d6.chance(of: ..<7), .one)
        XCTAssertEqual(d6.chance(of: ..<3), try! .init(1, outOf: 3))
        XCTAssertEqual(d6.chance(of: ..<1), .zero)
        
        XCTAssertEqual(d6.chance(of: ...7), .one)
        XCTAssertEqual(d6.chance(of: ...3), try! .init(1, outOf: 2))
        XCTAssertEqual(d6.chance(of: ...0), .zero)
    }
    
    func testDescription() {
        for _ in 0..<10 {
            let rand = Int.random(in: 1...1_000_000)
            let d = try! Die(sides: rand)
            XCTAssertEqual(d.description, "A \(d.sides)-sided die.")
        }
        XCTAssertEqual(Die.d6.description, "A 6-sided die.")
        
        for _ in 0..<10 {
            let rand = Int.random(in: 1...1_000_000)
            let d = try! Die(sides: rand)
            XCTAssertEqual(d.debugDescription, "d\(d.sides)")
        }
        XCTAssertEqual(Die.d6.debugDescription, "d6")
    }
}
