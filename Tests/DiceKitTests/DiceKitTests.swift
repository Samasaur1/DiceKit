@testable import DiceKit
import XCTest

final class DiceKitTests: XCTestCase {
    func testDiePlusDiceAdding() {
        let dice = Dice(.d4, .d6, withModifier: 5)
        let dice2 = Dice(.d4, .d6, .d6, withModifier: 5)
        XCTAssertEqual(dice + Die.d6, dice2)
        XCTAssertNotEqual(dice + Die.d8, dice2)
    }

    func testDicePlusTupleAdding() {
        let dice = Dice(.d4, withModifier: 5)
        let dice2 = Dice(.d4, .d6, .d6, withModifier: 5)
        XCTAssertEqual(dice + (Die.d6, 2), dice2)
        XCTAssertNotEqual(dice + (Die.d6, 1), dice2)
    }

    func testDiePlusDieAdding() {
        let dice = Dice(.d4, .d6)
        XCTAssertEqual(Die.d4 + Die.d6, dice)
        XCTAssertNotEqual(Die.d4 + Die.d8, dice)
    }

    func testDiePlusIntAdding() {
        let dice = Dice(.d6, withModifier: 5)
        XCTAssertEqual(Die.d6 + 5, dice)
    }

    func testDiePlusTupleAdding() {
        let dice = Dice(.d6, .d4, .d4)
        XCTAssertEqual(Die.d6 + (.d4, 2), dice)
    }

    func testDieTimesIntMultiplication() {
        let dice = Dice(.d6, count: 3)
        XCTAssertEqual(.d6 * 3, dice)
    }

//    func testRollable() {
//        for _ in 0...3 {
//            let r = try! getRollable()
//            for _ in 0...3 {
//                let roll = r.roll()
//                XCTAssert((r.minimumResult...r.maximumResult).contains(roll))
//                XCTAssertGreaterThan(r.probabilities[of: roll].value, 0)
//                XCTAssert(r.canReach(roll, .exactly))
//            }
//        }
//    }
    func testDieRollable() {
        let r = try! getRollable(die: true)
        for _ in 0...3 {
            let roll = r.roll()
            XCTAssert((r.minimumResult...r.maximumResult).contains(roll))
            XCTAssertGreaterThan(r.probabilities[of: roll].value, 0)
            XCTAssert(r.canReach(roll, .exactly))
        }
    }
    func testDiceRollable() {
        let r = try! { () -> Dice in
            var d = Dice(dice: [])
            for i in 1...Int.random(in: 2...5) {
                d += (try getRollable(die: true) as! Die, i % 3)
            }
            d += Int.random(in: -10...10)
            return d
            }()
        for _ in 0...3 {
            let roll = r.roll()
            XCTAssert((r.minimumResult...r.maximumResult).contains(roll))
            XCTAssertGreaterThan(r.probabilities[of: roll].value, 0)
            XCTAssert(r.canReach(roll, .exactly))
        }
    }
    func testWeightedDieRollable() {
        let r = try! { () -> WeightedDie in
            var c = Chances()
            for _ in 1...Int.random(in: 2...25) {
                c[of: Int.random(in: 1...25)] = try Chance(approximating: Double.random(in: 0..<1))
            }
            return try WeightedDie(chances: c)
            }()
        for _ in 0...3 {
            let roll = r.roll()
            XCTAssert((r.minimumResult...r.maximumResult).contains(roll))
            XCTAssertGreaterThan(r.probabilities[of: roll].value, 0)
            XCTAssert(r.canReach(roll, .exactly))
        }
    }
}

internal func getRollable(die: Bool = false) throws -> Rollable {
    switch die ? 1 : Int.random(in: 1...5) {
    case 1:
        return try Die(sides: Int.random(in: 1...25))
    case 2:
        var d = Dice(dice: [])
        for i in 1...Int.random(in: 2...5) {
            d += (try getRollable(die: true) as! Die, i % 3)
        }
        d += Int.random(in: -10...10)
        return d
    case 3:
        var c = Chances()
        for _ in 1...Int.random(in: 2...25) {
            c[of: Int.random(in: 1...25)] = try Chance(approximating: Double.random(in: 0..<1))
        }
        return try WeightedDie(chances: c)
    default:
        return try getRollable(die: true)
    }
}
