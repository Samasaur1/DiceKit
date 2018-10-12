import XCTest
@testable import DiceKit

final class DiceTests: XCTestCase {
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
        
    }
    
    func testSingleDieAndSingleModifierStringParsing() {
        
    }
    
    func testMultipleDieAndMultipleModifierStringParsing() {
        
    }
}
