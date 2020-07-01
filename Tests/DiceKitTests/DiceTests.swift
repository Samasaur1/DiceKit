@testable import DiceKit
import XCTest

final class DiceTests: XCTestCase {
    func testEmptyStringParsing() {
        let empty = try? Dice("")

        XCTAssertNotNil(empty)

        XCTAssertEqual(empty, Dice(dice: [], withModifier: 0))
    }

    func testSingleDieStringParsing() {
        let dice6_1 = try? Dice("d6")
        let dice6_2 = try? Dice("D6")
        let dice12 = try? Dice("d12")
        let dice100 = try? Dice("d100")
        let dice726 = try? Dice("d726")

        XCTAssertNotNil(dice6_1)
        XCTAssertNotNil(dice6_2)
        XCTAssertNotNil(dice12)
        XCTAssertNotNil(dice100)
        XCTAssertNotNil(dice726)

        XCTAssertEqual(dice6_1, Dice(Die.d6))
        XCTAssertEqual(dice6_2, Dice(Die.d6))
        XCTAssertEqual(dice12, Dice(Die.d12))
        XCTAssertEqual(dice100, Dice(Die.d100))
        XCTAssertEqual(dice726, Dice(try! Die(sides: 726)))

        XCTAssertNil(try? Dice("-d6"))
    }

    func testSingleModifierStringParsing() {
        let positive5_1 = try? Dice("5")
        let positive5_2 = try? Dice("+5")
        let negative5_1 = try? Dice("-5")
        let negative5_2 = try? Dice("+-5")

        XCTAssertNotNil(positive5_1)
        XCTAssertNotNil(positive5_2)
        XCTAssertNotNil(negative5_1)
        XCTAssertNotNil(negative5_2)

        XCTAssertEqual(positive5_1, Dice(dice: [], withModifier: 5))
        XCTAssertEqual(positive5_2, Dice(dice: [], withModifier: 5))
        XCTAssertEqual(negative5_1, Dice(dice: [], withModifier: -5))
        XCTAssertEqual(negative5_2, Dice(dice: [], withModifier: -5))
    }

    func testMultipleRepeatedDieStringParsing() {
        let dice2d6 = try? Dice("2d6")
        let dice3d4 = try? Dice("3D4")
        let dice12d12 = try? Dice("12d12")
        let dice1d100 = try? Dice("1d100")
        let dice1000d1 = try? Dice("1000d1")

        XCTAssertNotNil(dice2d6)
        XCTAssertNotNil(dice3d4)
        XCTAssertNotNil(dice12d12)
        XCTAssertNotNil(dice1d100)
        XCTAssertNotNil(dice1000d1)

        XCTAssertEqual(dice2d6, Dice(Die.d6, Die.d6))
        XCTAssertEqual(dice3d4, Dice(Die.d4, Die.d4, Die.d4))
        XCTAssertEqual(dice12d12, Dice((Die.d12, 12)))
        XCTAssertEqual(dice1d100, Dice(Die.d100))
        XCTAssertEqual(dice1000d1, Dice(try! Die(sides: 1), count: 1_000))
    }

    func testMultipleSeparateDieStringParsing() {
        let dice2d6withSpaces = try? Dice("d6 + 1d6")
        let dice2d6withoutSpaces = try? Dice("d6+1d6")
        let dice1d4plus1d6withSpaces = try? Dice("d4 + 1d6")
        let dice1d4plus1d6withoutSpaces = try? Dice("1d4+d6")

        XCTAssertNotNil(dice2d6withSpaces)
        XCTAssertNotNil(dice2d6withoutSpaces)
        XCTAssertNotNil(dice1d4plus1d6withSpaces)
        XCTAssertNotNil(dice1d4plus1d6withoutSpaces)

        XCTAssertEqual(dice2d6withSpaces, Dice(Die.d6, Die.d6))
        XCTAssertEqual(dice2d6withoutSpaces, Dice(Die.d6, Die.d6))
        XCTAssertEqual(dice1d4plus1d6withSpaces, Dice(Die.d4, Die.d6))
        XCTAssertEqual(dice1d4plus1d6withoutSpaces, Dice(Die.d4, Die.d6))

        let dice6d6withSpaces = try? Dice("d6 + 2d6 + 3d6")
        let dice6d6withoutSpaces = try? Dice("d6+2d6+3d6")

        XCTAssertNotNil(dice6d6withSpaces)
        XCTAssertNotNil(dice6d6withoutSpaces)

        XCTAssertEqual(dice6d6withSpaces, Dice(Die.d6, count: 6))
        XCTAssertEqual(dice6d6withoutSpaces, Dice(Die.d6, count: 6))
    }

    func testMultipleModifierStringParsing() {
        let _2plus3 = try? Dice("2+3")
        let _7minus2 = try? Dice("7-2")
        let negative2plus7 = try? Dice("-2+7")
        let negative2minus3 = try? Dice("-2-3")
        let _2minus7 = try? Dice("+2-7")

        XCTAssertNotNil(_2plus3)
        XCTAssertNotNil(_7minus2)
        XCTAssertNotNil(negative2plus7)
        XCTAssertNotNil(negative2minus3)
        XCTAssertNotNil(_2minus7)

        XCTAssertEqual(_2plus3, Dice(dice: [], withModifier: 5))
        XCTAssertEqual(_7minus2, Dice(dice: [], withModifier: 5))
        XCTAssertEqual(negative2plus7, Dice(dice: [], withModifier: 5))
        XCTAssertEqual(negative2minus3, Dice(dice: [], withModifier: -5))
        XCTAssertEqual(_2minus7, Dice(dice: [], withModifier: -5))
    }

    func testSingleDieAndSingleModifierStringParsing() {
        //Sucessfuls
        let d6plus6_1 = try? Dice("d6+6")
        let d6plus6_2 = try? Dice("6+d6")
        let d4minus4_1 = try? Dice("d4-4")
        let d4minus4_2 = try? Dice("-4+d4")

        XCTAssertNotNil(d6plus6_1)
        XCTAssertNotNil(d6plus6_2)
        XCTAssertNotNil(d4minus4_1)
        XCTAssertNotNil(d4minus4_2)

        //Unsucessfuls - NIL
        XCTAssertNil(try? Dice("-d8+8"))
        XCTAssertNil(try? Dice("8-d8"))
        XCTAssertNil(try? Dice("-d8-8"))
        XCTAssertNil(try? Dice("-8-d8"))

        XCTAssertEqual(d6plus6_1, Dice(dice: [Die.d6], withModifier: 6))
        XCTAssertEqual(d6plus6_2, Dice(dice: [Die.d6], withModifier: 6))
        XCTAssertEqual(d4minus4_1, Dice(dice: [Die.d4], withModifier: -4))
        XCTAssertEqual(d4minus4_2, Dice(dice: [Die.d4], withModifier: -4))
    }

    func testMultipleDieAndMultipleModifierStringParsing() {
        //2d6+12
        let D6plus6plus6plusD6 = try? Dice("d6+6+6+d6")
        let _6plusD6plusD6plus6 = try? Dice("6+d6+d6+6")
        let D6plus6plusD6plus6 = try? Dice("d6+6+d6+6")
        let _6plusD6plus6plusD6 = try? Dice("6+d6+6+d6")

        //2d4-8
        let D4minus4minus4plusD4 = try? Dice("d4-4-4+d4")
        let negative4plusD4plusD4minus4 = try? Dice("-4+d4+d4-4")
        let D4minus4plusD4minus4 = try? Dice("d4-4+d4-4")
        let negative4plusD4minus4plusD4 = try? Dice("-4+d4-4+d4")

        //2d8
        let D8plus8minus8plusD8 = try? Dice("d8+8-8+d8")
        let negative8plusD8plusD8plus8 = try? Dice("-8+d8+d8+8")
        let D8plus8plusD8minus8 = try? Dice("d8+8+d8-8")
        let negative8plusD8plus8plusD8 = try? Dice("-8+d8+8+d8")

        //20
        let D10plus10plus10minusD10 = try? Dice("d10+10+10-d10")
        let _10plusD10minusD10plus10 = try? Dice("10+d10-d10+10")
        let D10plus10minusD10plus10 = try? Dice("d10+10-d10+10")
        let _10plusD10plus10minusD10 = try? Dice("10+d10+10-d10")

        XCTAssertNotNil(D6plus6plus6plusD6)
        XCTAssertNotNil(_6plusD6plusD6plus6)
        XCTAssertNotNil(D6plus6plusD6plus6)
        XCTAssertNotNil(_6plusD6plus6plusD6)
        XCTAssertNotNil(D4minus4minus4plusD4)
        XCTAssertNotNil(negative4plusD4plusD4minus4)
        XCTAssertNotNil(D4minus4plusD4minus4)
        XCTAssertNotNil(negative4plusD4minus4plusD4)
        XCTAssertNotNil(D8plus8minus8plusD8)
        XCTAssertNotNil(negative8plusD8plusD8plus8)
        XCTAssertNotNil(D8plus8plusD8minus8)
        XCTAssertNotNil(negative8plusD8plus8plusD8)
        XCTAssertNotNil(D10plus10plus10minusD10)
        XCTAssertNotNil(_10plusD10minusD10plus10)
        XCTAssertNotNil(D10plus10minusD10plus10)
        XCTAssertNotNil(_10plusD10plus10minusD10)

        XCTAssertAllEqual(D6plus6plus6plusD6, _6plusD6plusD6plus6, D6plus6plusD6plus6, _6plusD6plus6plusD6, Dice(dice: [Die.d6, Die.d6], withModifier: 12))

        XCTAssertAllEqual(D4minus4minus4plusD4, negative4plusD4plusD4minus4, D4minus4plusD4minus4, negative4plusD4minus4plusD4, Dice(dice: [Die.d4, Die.d4], withModifier: -8))

        XCTAssertAllEqual(D8plus8minus8plusD8, negative8plusD8plusD8plus8, D8plus8plusD8minus8, negative8plusD8plus8plusD8, Dice(dice: [Die.d8, Die.d8], withModifier: 0))

        XCTAssertAllEqual(D10plus10plus10minusD10, _10plusD10minusD10plus10, D10plus10minusD10plus10, _10plusD10plus10minusD10, Dice(dice: [], withModifier: 20))
    }

    func testInvalidStringParsing() {
        // Assorted
        XCTAssertNil(try? Dice("d")) // d without value
        XCTAssertNil(try? Dice("q1")) // other that d in front
        XCTAssertNil(try? Dice("d1b")) // binary (other form with d)
        XCTAssertNil(try? Dice("1o")) // octal (other forw without d)
        XCTAssertNil(try? Dice("one")) // spelled out
        XCTAssertNil(try? Dice("A")) // hexadecimal
        XCTAssertNil(try? Dice("DiceKit")) // string
        XCTAssertNil(try? Dice("d+6")) // split
        XCTAssertNil(try? Dice("d0")) // 0-sided die

        //Negative
        XCTAssertNil(try? Dice("-d6"))
        XCTAssertNil(try? Dice("d-6"))
    }

    func testAverageResult() {
        XCTAssertEqual(Dice(dice: [Die.d6], withModifier: 6).averageResult, 10)

        for _ in 1...5 {
            let numDice = Int.random(in: 1...10_000)

            let optionalDie = try? Die(sides: Int.random(in: 1...10_000))
            guard let die = optionalDie else {
                XCTFail()
                continue
            }

            let mod = Int.random(in: -1_000...1_000) // 0...2000 // 1...2001
            let d = Dice(die, count: numDice, withModifier: mod)
            XCTAssertEqual(d.averageResult, Int((die.doubleAverageResult * Double(numDice) + Double(mod)).rounded()))
        }
    }

    func testChance() {
        let d = Dice(Die.d6, count: 2)
        let chance = d.chance(of: 2, .exactly)
        XCTAssertEqual(chance, try! Chance(1, outOf: 36))

        let chance2 = d.chance(of: 2, .orHigher)
        XCTAssertEqual(chance2, Chance.one)

        let chance3 = d.chance(of: 1, .orLower)
        XCTAssertEqual(chance3, Chance.zero)
    }
    
    func testInitialization() {
        //String parsing is handled separately
        
        let d = Dice(.d6, .d6, .d4)
        let d2 = Dice(dice: [.d6, .d6, .d4])
        let d3 = Dice(.d6, count: 2) + Dice(.d4, count: 1)
        let d4 = Dice((die: .d6, count: 2), (.d4, 1))
        
        XCTAssertAllEqual(d, d2, d3, d4)
        
        let _d7 = try! Die(sides: 7)
        let d5 = Dice(.d8, _d7.copy(), withModifier: 6)
        let d6 = Dice(dice: [.d8, _d7.copy()], withModifier: 6)
        let d7 = Dice(.d8, count: 1, withModifier: 6) + _d7.copy()
        let d8 = Dice((.d8, 1), (_d7.copy(), 1), withModifier: 6)
        
        XCTAssertAllEqual(d5, d6, d7, d8)
    }
    
    func testCopying() {
        let _1 = Dice(.d6, count: 2, withModifier: 3)
        let _2 = Dice(copyOf: _1)
        let _3 = _1.copy()
        XCTAssertAllEqual(_1, _2, _3)
    }
    
    func testRolling() {
        #warning("DiceTests.testRolling not implemented")
    }
    
    func testCanReach() {
        //See DiceKitTests.testRollable()
    }
    
    func testEquatable() {
        let _2d6 = Dice(.d6, count: 2)
        let __2d6 = Dice(.d6, .d6)
        XCTAssertEqual(_2d6, __2d6)
        let _2d6plus1 = Dice(.d6, count: 2, withModifier: 1)
        XCTAssertNotEqual(_2d6, _2d6plus1)
        let _d6 = Dice(.d6)
        XCTAssertNotEqual(_d6, _2d6)
        let _d6plus1 = Dice(.d6, withModifier: 1)
        XCTAssertNotEqual(_d6plus1, _2d6plus1)
        let _2d4 = Dice(.d4, count: 2)
        XCTAssertNotEqual(_2d4, _2d6)
        let _d4 = Dice(.d4)
        XCTAssertNotEqual(_d4, _d6)
    }
    
    func testDescription() {
        let dice = Dice(.d6, .d6, .d4, withModifier: 2)
        XCTAssertEqual(dice.description, "2 6-sided dice, 1 4-sided die, with a modifier of 2.")
        XCTAssertEqual(dice.debugDescription, "2d6 + 1d4 + 2")
    }
    
    func testDicePlusDiceAdding() {
        let dice1 = Dice(.d10, .d6, .d6, .d4, withModifier: 2)
        let dice2 = Dice(.d6, .d4, .d8, withModifier: 2)
        let sum = dice1 + dice2
        
        XCTAssertEqual(sum, Dice(.d10, .d8, .d6, .d6, .d6, .d4, .d4, withModifier: 4))
        
        var mutable = dice1.copy()
        mutable += dice2
        XCTAssertEqual(sum, mutable)
    }
    
    func testDicePlusIntAdding() {
        let dice = Dice(.d6, .d6, .d4, withModifier: 2)
        let sum = dice + 2
        
        XCTAssertEqual(sum, Dice(.d6, .d6, .d4, withModifier: 4))
        
        var mutable = dice.copy()
        mutable += 2
        XCTAssertEqual(sum, mutable)
    }
    
    func testDiceMinusIntSubtracting() {
        let dice = Dice(.d6, .d6, .d4, withModifier: 2)
        let sum = dice - 1
        
        XCTAssertEqual(sum, Dice(.d6, .d6, .d4, withModifier: 1))
        
        var mutable = dice.copy()
        mutable -= 1
        XCTAssertEqual(sum, mutable)
    }
    
    func testDiceTimesIntMultiplication() {
        let dice = Dice(.d6, .d6, .d4, withModifier: 3)
        let sum = dice * 2
        
        XCTAssertEqual(sum, Dice(.d6, .d6, .d6, .d6, .d4, .d4, withModifier: 6))
        
        var mutable = dice.copy()
        mutable *= 2
        XCTAssertEqual(sum, mutable)
    }
    
    func testRollingMultipleTimes() {
        #warning("DiceTests.testRollingMultipleTimes not implemented")
    }
    
    func testChanceInRange() {
        let dice = Dice(.d6, .d6, withModifier: 1)
        XCTAssertEqual(dice.chance(of: 3...13), .one)
        XCTAssertEqual(dice.chance(of: 3..<4), try! .init(1, outOf: 36))
        XCTAssertEqual(dice.chance(of: 3..<5), try! .init(3, outOf: 36))
        XCTAssertEqual(dice.chance(of: 8...), try! .init(7, outOf: 12))
        XCTAssertEqual(dice.chance(of: ...7), try! .init(5, outOf: 12))
        XCTAssertEqual(dice.chance(of: ..<3), .zero)
    }
    
    func testNegativeMultipleDieStringParsing() {
        let diced6 = try? Dice("3d6 - 2d6")
        let diced4 = try? Dice("4D4 - 3D4")
        let dice6d12 = try? Dice("12d12- 6d12")
        let dice980d1 = try? Dice("-4d1 +1000d1 -10d1 - 2d1- 3d1-5d1+ 4d1")
        
        XCTAssertNotNil(diced6)
        XCTAssertNotNil(diced4)
        XCTAssertNotNil(dice6d12)
        XCTAssertNotNil(dice980d1)
        
        XCTAssertEqual(diced6, Dice(Die.d6))
        XCTAssertEqual(diced4, Dice(Die.d4))
        XCTAssertEqual(dice6d12, Dice((Die.d12, 6)))
        XCTAssertEqual(dice980d1, Dice(try! Die(sides: 1), count: 980))
    }

    func testProbabilities() {
        let empty = Dice(dice: [])
        let five = Dice(dice: [], withModifier: 5)
        let d4 = Dice(.d4)
        let d6plus1 = Dice(.d6, withModifier: 1)

        XCTAssertEqual(empty.probabilities, Chances(chances: [0: .one]))
        XCTAssertEqual(five.probabilities, Chances(chances: [5: .one]))
        let c = try! Chance.oneOut(of: 4)
        XCTAssertEqual(d4.probabilities, Chances(chances: [1: c, 2: c, 3: c, 4: c]))
        let c2 = try! Chance.oneOut(of: 6)
        XCTAssertEqual(d6plus1.probabilities, Chances(chances: [2: c2, 3: c2, 4: c2, 5: c2, 6: c2, 7: c2]))
    }
}
