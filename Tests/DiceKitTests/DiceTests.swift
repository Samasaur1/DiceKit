import XCTest
@testable import DiceKit

final class DiceTests: XCTestCase {
    func testEmptyStringParsing() {
        let empty = Dice("")
        
        XCTAssertNotNil(empty)
        
        XCTAssertEqual(empty, Dice(dice: [], withModifier: 0))
    }
    
    func testSingleDieStringParsing() {
        let dice6_1 = Dice("d6")
        let dice6_2 = Dice("D6")
        let dice12 = Dice("d12")
        let dice100 = Dice("d100")
        let dice726 = Dice("d726")
        
        XCTAssertNotNil(dice6_1)
        XCTAssertNotNil(dice6_2)
        XCTAssertNotNil(dice12)
        XCTAssertNotNil(dice100)
        XCTAssertNotNil(dice726)
        
        XCTAssertEqual(dice6_1, Dice(Die.d6))
        XCTAssertEqual(dice6_2, Dice(Die.d6))
        XCTAssertEqual(dice12, Dice(Die.d12))
        XCTAssertEqual(dice100, Dice(Die.d100))
        XCTAssertEqual(dice726, Dice(Die(sides: 726)!))
        
        XCTAssertNil(Dice("-d6"))
    }
    
    func testSingleModifierStringParsing() {
        let positive5_1 = Dice("5")
        let positive5_2 = Dice("+5")
        let negative5_1 = Dice("-5")
        let negative5_2 = Dice("+-5")
        
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
        let dice2d6 = Dice("2d6")
        let dice3d4 = Dice("3D4")
        let dice12d12 = Dice("12d12")
        let dice1d100 = Dice("1d100")
        let dice1000d1 = Dice("1000d1")
        
        XCTAssertNotNil(dice2d6)
        XCTAssertNotNil(dice3d4)
        XCTAssertNotNil(dice12d12)
        XCTAssertNotNil(dice1d100)
        XCTAssertNotNil(dice1000d1)
        
        XCTAssertEqual(dice2d6, Dice(Die.d6, Die.d6))
        XCTAssertEqual(dice3d4, Dice(Die.d4, Die.d4, Die.d4))
        XCTAssertEqual(dice12d12, Dice((Die.d12, 12)))
        XCTAssertEqual(dice1d100, Dice(Die.d100))
        XCTAssertEqual(dice1000d1, Dice(Die(sides: 1)!, count: 1000))
    }
    
    func testMultipleSeparateDieStringParsing() {
        let dice2d6withSpaces = Dice("d6 + 1d6")
        let dice2d6withoutSpaces = Dice("d6+1d6")
        let dice1d4plus1d6withSpaces = Dice("d4 + 1d6")
        let dice1d4plus1d6withoutSpaces = Dice("1d4+d6")
        
        XCTAssertNotNil(dice2d6withSpaces)
        XCTAssertNotNil(dice2d6withoutSpaces)
        XCTAssertNotNil(dice1d4plus1d6withSpaces)
        XCTAssertNotNil(dice1d4plus1d6withoutSpaces)
        
        XCTAssertEqual(dice2d6withSpaces, Dice(Die.d6, Die.d6))
        XCTAssertEqual(dice2d6withoutSpaces, Dice(Die.d6, Die.d6))
        XCTAssertEqual(dice1d4plus1d6withSpaces, Dice(Die.d4, Die.d6))
        XCTAssertEqual(dice1d4plus1d6withoutSpaces, Dice(Die.d4, Die.d6))
        
        
        
        let dice6d6withSpaces = Dice("d6 + 2d6 + 3d6")
        let dice6d6withoutSpaces = Dice("d6+2d6+3d6")
        
        XCTAssertNotNil(dice6d6withSpaces)
        XCTAssertNotNil(dice6d6withoutSpaces)
        
        XCTAssertEqual(dice6d6withSpaces, Dice(Die.d6, count: 6))
        XCTAssertEqual(dice6d6withoutSpaces, Dice(Die.d6, count: 6))
    }
    
    func testMultipleModifierStringParsing() {
        let _2plus3 = Dice("2+3")
        let _7minus2 = Dice("7-2")
        let negative2plus7 = Dice("-2+7")
        let negative2minus3 = Dice("-2-3")
        let _2minus7 = Dice("+2-7")
        
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
        let d6plus6_1 = Dice("d6+6")
        let d6plus6_2 = Dice("6+d6")
        let d4minus4_1 = Dice("d4-4")
        let d4minus4_2 = Dice("-4+d4")
        
        //Unsucessfuls - NIL
        let negatived8plus8_1 = Dice("-d8+8")
        let negatived8plus8_2 = Dice("8-d8")
        let negatived8minus8_1 = Dice("-d8-8")
        let negatived8minus8_2 = Dice("-8-d8")
        
        XCTAssertNotNil(d6plus6_1)
        XCTAssertNotNil(d6plus6_2)
        XCTAssertNotNil(d4minus4_1)
        XCTAssertNotNil(d4minus4_2)
        
        XCTAssertNil(negatived8plus8_1)
        XCTAssertNil(negatived8plus8_2)
        XCTAssertNil(negatived8minus8_1)
        XCTAssertNil(negatived8minus8_2)
        
        XCTAssertEqual(d6plus6_1, Dice(dice: [Die.d6], withModifier: 6))
        XCTAssertEqual(d6plus6_2, Dice(dice: [Die.d6], withModifier: 6))
        XCTAssertEqual(d4minus4_1, Dice(dice: [Die.d4], withModifier: -4))
        XCTAssertEqual(d4minus4_2, Dice(dice: [Die.d4], withModifier: -4))
    }
    
    func testMultipleDieAndMultipleModifierStringParsing() {
        //2d6+12
        let D6plus6plus6plusD6 = Dice("d6+6+6+d6")
        let _6plusD6plusD6plus6 = Dice("6+d6+d6+6")
        let D6plus6plusD6plus6 = Dice("d6+6+d6+6")
        let _6plusD6plus6plusD6 = Dice("6+d6+6+d6")
        
        //2d4-8
        let D4minus4minus4plusD4 = Dice("d4-4-4+d4")
        let negative4plusD4plusD4minus4 = Dice("-4+d4+d4-4")
        let D4minus4plusD4minus4 = Dice("d4-4+d4-4")
        let negative4plusD4minus4plusD4 = Dice("-4+d4-4+d4")
        
        //2d8
        let D8plus8minus8plusD8 = Dice("d8+8-8+d8")
        let negative8plusD8plusD8plus8 = Dice("-8+d8+d8+8")
        let D8plus8plusD8minus8 = Dice("d8+8+d8-8")
        let negative8plusD8plus8plusD8 = Dice("-8+d8+8+d8")
        
        //20
        let D10plus10plus10minusD10 = Dice("d10+10+10-d10")
        let _10plusD10minusD10plus10 = Dice("10+d10-d10+10")
        let D10plus10minusD10plus10 = Dice("d10+10-d10+10")
        let _10plusD10plus10minusD10 = Dice("10+d10+10-d10")
        
        
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
        
        
        XCTAssertEqual(D6plus6plus6plusD6, Dice(dice: [Die.d6, Die.d6], withModifier: 12))
        XCTAssertEqual(_6plusD6plusD6plus6, Dice(dice: [Die.d6, Die.d6], withModifier: 12))
        XCTAssertEqual(D6plus6plusD6plus6, Dice(dice: [Die.d6, Die.d6], withModifier: 12))
        XCTAssertEqual(_6plusD6plus6plusD6, Dice(dice: [Die.d6, Die.d6], withModifier: 12))
        
        XCTAssertEqual(D4minus4minus4plusD4, Dice(dice: [Die.d4, Die.d4], withModifier: -8))
        XCTAssertEqual(negative4plusD4plusD4minus4, Dice(dice: [Die.d4, Die.d4], withModifier: -8))
        XCTAssertEqual(D4minus4plusD4minus4, Dice(dice: [Die.d4, Die.d4], withModifier: -8))
        XCTAssertEqual(negative4plusD4minus4plusD4, Dice(dice: [Die.d4, Die.d4], withModifier: -8))
        
        XCTAssertEqual(D8plus8minus8plusD8, Dice(dice: [Die.d8, Die.d8], withModifier: 0))
        XCTAssertEqual(negative8plusD8plusD8plus8, Dice(dice: [Die.d8, Die.d8], withModifier: 0))
        XCTAssertEqual(D8plus8plusD8minus8, Dice(dice: [Die.d8, Die.d8], withModifier: 0))
        XCTAssertEqual(negative8plusD8plus8plusD8, Dice(dice: [Die.d8, Die.d8], withModifier: 0))
        
        XCTAssertEqual(D10plus10plus10minusD10, Dice(dice: [], withModifier: 20))
        XCTAssertEqual(_10plusD10minusD10plus10, Dice(dice: [], withModifier: 20))
        XCTAssertEqual(D10plus10minusD10plus10, Dice(dice: [], withModifier: 20))
        XCTAssertEqual(_10plusD10plus10minusD10, Dice(dice: [], withModifier: 20))
    }
    
    func testInvalidStringParsing() {
        // Assorted
        XCTAssertNil(Dice("d")) // d without value
        XCTAssertNil(Dice("q1")) // other that d in front
        XCTAssertNil(Dice("d1b")) // binary (other form with d)
        XCTAssertNil(Dice("1o")) // octal (other forw without d)
        XCTAssertNil(Dice("one")) // spelled out
        XCTAssertNil(Dice("A")) // hexadecimal
        XCTAssertNil(Dice("DiceKit")) // string
        XCTAssertNil(Dice("d+6")) // split
        
        //Negative
        XCTAssertNil(Dice("-d6"))
        XCTAssertNil(Dice("d-6"))
    }
}
