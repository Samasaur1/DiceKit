@testable import DiceKit
import XCTest

final class RollableTests: XCTestCase {
    func testRollable() {
        for i in 0...3 {
            let r = try! getRollable()
            print("\(r)", to: &STDOUT)
            for _ in 0...3 {
                let roll = r.roll()
                XCTAssert((r.minimumResult...r.maximumResult).contains(roll))
                XCTAssertGreaterThan(r.probabilities[of: roll].value, 0)
                XCTAssert(r.canReach(roll, .exactly))
            }
            print("Rollable {\(r)}, #\(i+1) completed", to: &STDOUT)
        }
    }
    
    func testDieRollable() {
        let r = try! getDie()
        for _ in 0...3 {
            let roll = r.roll()
            XCTAssert((r.minimumResult...r.maximumResult).contains(roll))
            XCTAssertGreaterThan(r.probabilities[of: roll].value, 0)
            XCTAssert(r.canReach(roll, .exactly))
        }
    }
    
    func testWeightedDieRollable() {
        let r = try! getWeightedDie()
        print("\(r)", to: &STDOUT)
        for _ in 0...3 {
            let roll = r.roll()
            XCTAssert((r.minimumResult...r.maximumResult).contains(roll))
            XCTAssertGreaterThan(r.probabilities[of: roll].value, 0)
            XCTAssert(r.canReach(roll, .exactly))
        }
    }
    
    func testDiceRollable() {
        let r = try! getDice()
        print("\(r)", to: &STDOUT)
        for _ in 0...3 {
            let roll = r.roll()
            XCTAssert((r.minimumResult...r.maximumResult).contains(roll))
            XCTAssertGreaterThan(r.probabilities[of: roll].value, 0, "Roll was \(roll)")
            XCTAssert(r.canReach(roll, .exactly))
        }
    }
    
    func test2d5plusd18minus4() {
        let d = try! Dice("2d25+d18-4")
        for _ in 0...3 {
            let roll = d.roll()
            XCTAssertGreaterThan(d.probabilities[of: roll].value, 0, "Roll was \(roll)")
        }
    }
    func testRollTimesNegativeTimes() {
        let d6 = Die.d6
        let dice = try! Dice("3d6 +5")

        for mrr in MultipleRollResult.all {
            XCTAssertThrowsError(try d6.roll(times: -1, mrr), "Was incorrectly able to roll a negative number of times (\(mrr)) (using \(d6.debugDescription))")
            XCTAssertThrowsError(try d6.roll(times: -5, mrr), "Was incorrectly able to roll a negative number of times (\(mrr)) (using \(d6.debugDescription))")
            XCTAssertThrowsError(try dice.roll(times: -1, mrr), "Was incorrectly able to roll a negative number of times (\(mrr)) (using \(dice.debugDescription))")
            XCTAssertThrowsError(try dice.roll(times: -5, mrr), "Was incorrectly able to roll a negative number of times (\(mrr)) (using \(dice.debugDescription))")
        }
    }
    func testRollTimesZeroTimes() {
        let d6 = Die.d6
        let dice = try! Dice("3d6 +5")

        for mrr in MultipleRollResult.all {
            XCTAssertThrowsError(try d6.roll(times: 0, mrr), "Was incorrectly able to roll zero times (\(mrr)) (using \(d6.debugDescription))")
            XCTAssertThrowsError(try dice.roll(times: 0, mrr), "Was incorrectly able to roll zero times (\(mrr)) (using \(dice.debugDescription))")
        }
    }
    func testRollTimesTooFewTimes() {
        let d6 = Die.d6
        let dice = try! Dice("3d6 +5")

        XCTAssertThrowsError(try d6.roll(times: 1, .outsides), "Was incorrectly able to roll .outsides with one roll (using \(d6.debugDescription))")
        XCTAssertThrowsError(try dice.roll(times: 1, .outsides), "Was incorrectly able to roll .outsides with one roll (using \(dice.debugDescription))")

        XCTAssertThrowsError(try d6.roll(times: 1, .dropOutsides), "Was incorrectly able to roll .dropOutsides with one roll (using \(d6.debugDescription))")
        XCTAssertThrowsError(try dice.roll(times: 1, .dropOutsides), "Was incorrectly able to roll .dropOutsides with one roll (using \(dice.debugDescription))")

        for _mrr in [{ MultipleRollResult.dropLow(amountToDrop: $0) }, { MultipleRollResult.dropHigh(amountToDrop: $0) }] as [(Int) -> MultipleRollResult] {
            for d in [d6, dice] as [Rollable] {
                for atd in 3...5 {
                    for att in 1..<atd {
                        let mrr = _mrr(atd)
                        XCTAssertThrowsError(try d.roll(times: att, mrr), "Was incorrectly able to roll \(mrr) with \(att) roll(s) (using \((d as! CustomDebugStringConvertible).debugDescription))", {
                            guard let err = $0 as? DiceKit.Error else {
                                XCTFail("Rolling \(mrr) with \(att) roll(s) using \((d as! CustomDebugStringConvertible).debugDescription) threw a non-DiceKit error (\($0))")
                                return
                            }
                            XCTAssertEqual(err, Error.insufficientRollsForCalculation(attempt: att, minimum: atd))
                        })
                    }
                }
            }
        }
    }
    func testRollTimesOkayNumberOfTimes() {
        let d6 = Die.d6
        let dice = try! Dice("3d6 +5")

        for mrr in [MultipleRollResult.sum, .highest, .lowest, .dropHighest, .dropLowest, .dropHigh(amountToDrop: 0), .dropHigh(amountToDrop: 1), .dropLow(amountToDrop: 0), .dropLow(amountToDrop: 1)] {
            XCTAssertNoThrow(try d6.roll(times: 1, mrr), "Incorrectly threw an error with one roll (\(mrr)) (using \(d6.debugDescription))")
            XCTAssertNoThrow(try dice.roll(times: 1, mrr), "Incorrectly threw an error with one roll (\(mrr)) (using \(dice.debugDescription))")
        }

        for mrr in [MultipleRollResult.sum, .highest, .lowest, .outsides, .dropHighest, .dropLowest, .dropOutsides] + (0...2).map({ [MultipleRollResult.dropHigh(amountToDrop: $0), .dropLow(amountToDrop: $0)] }).joined() {
            XCTAssertNoThrow(try d6.roll(times: 2, mrr), "Incorrectly threw an error with two rolls (\(mrr)) (using \(d6.debugDescription))")
            XCTAssertNoThrow(try dice.roll(times: 2, mrr), "Incorrectly threw an error with two rolls (\(mrr)) (using \(dice.debugDescription))")
        }

        for mrr in [MultipleRollResult.sum, .highest, .lowest, .outsides, .dropHighest, .dropLowest, .dropOutsides] + (0...3).map({ [MultipleRollResult.dropHigh(amountToDrop: $0), .dropLow(amountToDrop: $0)] }).joined() {
            XCTAssertNoThrow(try d6.roll(times: 3, mrr), "Incorrectly threw an error with three rolls (\(mrr)) (using \(d6.debugDescription))")
            XCTAssertNoThrow(try dice.roll(times: 3, mrr), "Incorrectly threw an error with three rolls (\(mrr)) (using \(dice.debugDescription))")
        }

        for mrr in [MultipleRollResult.sum, .highest, .lowest, .outsides, .dropHighest, .dropLowest, .dropOutsides] + (0...4).map({ [MultipleRollResult.dropHigh(amountToDrop: $0), .dropLow(amountToDrop: $0)] }).joined() {
            XCTAssertNoThrow(try d6.roll(times: 4, mrr), "Incorrectly threw an error with four rolls (\(mrr)) (using \(d6.debugDescription))")
            XCTAssertNoThrow(try dice.roll(times: 4, mrr), "Incorrectly threw an error with four rolls (\(mrr)) (using \(dice.debugDescription))")
        }
    }
    func testRollTimesCorrectResult() {
        let d = try! Die(sides: 1)
        for i in 1..<5 {
            XCTAssertEqual(try d.roll(times: i, .sum), i, "The sum of \(i)d1 was not \(i)")
            XCTAssertEqual(try d.roll(times: i, .highest), 1, "The highest roll of \(i)d1 was not 1")
            XCTAssertEqual(try d.roll(times: i, .lowest), 1, "The lowest roll of \(i)d1 was not 1")
            if i > 1 {
                XCTAssertEqual(try d.roll(times: i, .outsides), 2, "The outisdes of \(i)d1 was not 2")
            }
            XCTAssertEqual(try d.roll(times: i, .dropHighest), i - 1, "Dropping the highest of \(i)d1 was not \(i-1)")
            XCTAssertEqual(try d.roll(times: i, .dropLowest), i - 1, "Dropping the lowest of \(i)d1 was not \(i-1)")
            if i > 1 {
                XCTAssertEqual(try d.roll(times: i, .dropOutsides), i - 2, "Dropping the outisdes of \(i)d1 was not \(i-2)")
            }
            for j in 0...i {
                XCTAssertEqual(try d.roll(times: i, .dropLow(amountToDrop: j)), i - j, "Dropping the lowest \(j) of \(i)d1 was not \(i-j)")
                XCTAssertEqual(try d.roll(times: i, .dropHigh(amountToDrop: j)), i - j, "Dropping the highest \(j) of \(i)d1 was not \(i-j)")
            }
        }
    }
    func testChanceOf() {}
}

internal extension MultipleRollResult {
    static var all: [MultipleRollResult] {
        switch MultipleRollResult.sum {
            case .sum: _ = 0
            case .highest: _ = 0
        case .lowest: _ = 0
        case .outsides: _ = 0
        case .dropHighest: _ = 0
        case .dropLowest: _ = 0
        case .dropOutsides: _ = 0
        case .dropLow(amountToDrop: _): _ = 0
        case .dropHigh(amountToDrop: _): _ = 0
        }
        return [.sum, .highest, .lowest, .outsides, .dropHighest, .dropLowest, .dropOutsides, .dropLow(amountToDrop: 3), .dropHigh(amountToDrop: 3)]
    }
}
