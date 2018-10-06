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
    
    func testMultipleDieStringParsing() {
        
    }
    
    func testMultipleModifierStringParsing() {
        
    }
    
    func testSingleDieAndSingleModifierStringParsing() {
        
    }
    
    func testMultipleDieAndMultipleModifierStringParsing() {
        
    }
}
