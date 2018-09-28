import XCTest
@testable import DiceKit

final class DieTests: XCTestCase {
    func testInitialization() {
        let negativeOneDie = Die(sides: -1)
        let zeroDie = Die(sides: 0)
        let d6 = Die(sides: 6)
        XCTAssertNil(negativeOneDie)
        XCTAssertNil(zeroDie)
        XCTAssertNotNil(d6)
    }
    
    func testSidesProperty() {
        for i in 1...100 {
            let die = Die(sides: i)!
            XCTAssertEqual(die.sides, i)
        }
    }
    
    func testCopying() {
        let firstDie = Die.d6
        let secondDie = Die.init(copyOf: firstDie)
        let thirdDie = firstDie.copy()
        XCTAssertEqual(firstDie.sides, secondDie.sides) //Testing Equatable is separate
        XCTAssertEqual(firstDie.sides, thirdDie.sides)
        XCTAssertEqual(secondDie.sides, thirdDie.sides)
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
            let d = Die(sides: i)!
            XCTAssertEqual(d.minimumResult, 1)
        }
    }
    
    func testMaximumResultProperty() {
        for i in 1...25 {
            let d = Die(sides: i)!
            XCTAssertEqual(d.maximumResult, d.sides)
        }
    }
    
    func testEquatable() {
        let d6 = Die.d6
        let initializedD6 = Die(sides: 6)!
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
}
