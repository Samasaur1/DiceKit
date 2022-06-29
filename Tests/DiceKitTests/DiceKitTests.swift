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

    func testFileHandleOutputStream__INTERNAL_UTILITY_METHOD() {
        print("STDOUT", to: &STDOUT)
        print("STDERR", to: &STDERR)
    }
}

internal func getDie() throws -> Die {
    return try Die(sides: Int.random(in: 1...25))
}

internal func getDice() throws -> Dice {
    var d = Dice(dice: [])
    let numDice = Int.random(in: 1...4)
    while d.numberOfDice < numDice {
        d += (try getDie(), Bool.random() ? 2 : 1)
    }
    d += Int.random(in: -10...10)
    return d
}

internal func getWeightedDie() throws -> WeightedDie {
    var c = Chances()
    for _ in 1...Int.random(in: 3...10) {
        c[of: Int.random(in: 1...500)] = try Chance(approximating: round(Double.random(in: 0..<1))*1000/1000)
    }
    let w: WeightedDie
    do {
        w = try WeightedDie(chances: c)
    } catch DiceKit.Error.emptyDictionary {
        print("Empty dictionary at line \(#line) in file \(#file)", to: &STDERR)
        w = try getWeightedDie()
    } catch let err {
        throw err
    }
    return w
}

internal func getRollable(die: Bool = false) throws -> Rollable {
    switch die ? 1 : Int.random(in: 1...5) {
    case 1:
        return try getDie()
    case 2:
        return try getDice()
    case 3:
        return try getWeightedDie()
    default:
        return try getRollable(die: true)
    }
}

internal func XCTAssertAllEqual<T>(_ items: T..., file: StaticString = #file, line: UInt = #line, _ message: String = "") where T: Equatable {
    for item in items {
        for other in items {
            XCTAssertEqual(item, other, message, file: file, line: line)
        }
    }
}
