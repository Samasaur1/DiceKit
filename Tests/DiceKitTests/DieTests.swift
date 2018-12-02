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
    
    func testSingleDigitStringParsing() {
        let d6_1 = Die("6")
        let d6_2 = Die("d6")
        let d6_3 = Die("D6")
        
        XCTAssertNotNil(d6_1)
        XCTAssertNotNil(d6_2)
        XCTAssertNotNil(d6_3)
        
        XCTAssertEqual(d6_1, Die.d6)
        XCTAssertEqual(d6_2, Die.d6)
        XCTAssertEqual(d6_3, Die.d6)
    }
    
    func testMultipleDigitStringParsing() {
        let d12_1 = Die("12")
        let d12_2 = Die("d12")
        let d12_3 = Die("D12")
        
        XCTAssertNotNil(d12_1)
        XCTAssertNotNil(d12_2)
        XCTAssertNotNil(d12_3)
        
        XCTAssertEqual(d12_1, Die.d12)
        XCTAssertEqual(d12_2, Die.d12)
        XCTAssertEqual(d12_3, Die.d12)
    }
    
    func testInvalidStringParsing() {
        // Assorted
        XCTAssertNil(Die("")) // empty
        XCTAssertNil(Die("d")) // d without value
        XCTAssertNil(Die("q1")) // other that d in front
        XCTAssertNil(Die("d1b")) // binary (other form with d)
        XCTAssertNil(Die("1o")) // octal (other forw without d)
        XCTAssertNil(Die("one")) // spelled out
        XCTAssertNil(Die("A")) // hexadecimal
        XCTAssertNil(Die("DiceKit")) // string
        
        //Negative
        XCTAssertNil(Die("-6"))
        XCTAssertNil(Die("-d6"))
        XCTAssertNil(Die("d-6"))
        
        //Positive
        XCTAssertNil(Die("+6"))
        XCTAssertNil(Die("+d6"))
        XCTAssertNil(Die("d+6"))
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
    
    func testCanReach() {
        let d6 = Die.d6
        
        for target in 1...6 {
            #if swift(>=4.2)
            for type in RollComparison.allCases {
                XCTAssertTrue(d6.canReach(target, type))
            }
            #else
            for type in [RollComparison.orLower, RollComparison.exactly, RollComparison.orHigher] {
                XCTAssertTrue(d6.canReach(target, type))
            }
            #endif
        }
        
        XCTAssertTrue(d6.canReach(8, .orLower))
        XCTAssertFalse(d6.canReach(8, .exactly))
        XCTAssertFalse(d6.canReach(8, .orHigher))
    }
    
    func testAverageResult() {
        XCTAssertEqual(Die.d6.averageResult, 4)
        
        for _ in 1...5 {
            #if swift(>=4.2)
            let r = Int.random(in: 1...10_000)
            #else
            #if os(macOS)
            let r = Int(arc4random_uniform(UInt32(10_000))) + 1
            #else
            if !DiceKit.initialized {
                srandom(UInt32(time(nil)))
                DiceKit.initialized = true
            }
            let r = (random() % 10_000) + 1
            #endif
            #endif
            guard let d = Die(sides: r) else {
                XCTFail()
                continue
            }
            XCTAssertEqual(d.averageResult, Int((Double(r + 1)/2).rounded()))
        }
    }
    
    func testDoubleAverageResult() {
        XCTAssertEqual(Die.d6.doubleAverageResult, 3.5)
        
        for _ in 1...5 {
            #if swift(>=4.2)
            let r = Int.random(in: 1...10_000)
            #else
            #if os(macOS)
            let r = Int(arc4random_uniform(UInt32(10_000))) + 1
            #else
            if !DiceKit.initialized {
                srandom(UInt32(time(nil)))
                DiceKit.initialized = true
            }
            let r = (random() % 10_000) + 1
            #endif
            #endif
            guard let d = Die(sides: r) else {
                XCTFail()
                continue
            }
            XCTAssertEqual(d.doubleAverageResult, Double(r + 1)/2)
        }
    }
    
    func testMinAverageMax() {
        for _ in 1...10 {
            #if swift(>=4.2)
            let optionalDie = Die(sides: Int.random(in: 1...1000000))
            #else
            #if os(macOS)
            let optionalDie = Die(sides: Int(arc4random_uniform(UInt32(1000000))) + 1)
            #else
            if !DiceKit.initialized {
                srandom(UInt32(time(nil)))
                DiceKit.initialized = true
            }
            let optionalDie = Die(sides: (random() % 1000000) + 1)
            #endif
            #endif
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
        XCTAssertEqual(Die.d4, Die(sides: 4)!)
        XCTAssertEqual(Die.d6, Die(sides: 6)!)
        XCTAssertEqual(Die.d8, Die(sides: 8)!)
        XCTAssertEqual(Die.d10, Die(sides: 10)!)
        XCTAssertEqual(Die.d12, Die(sides: 12)!)
        XCTAssertEqual(Die.d20, Die(sides: 20)!)
        XCTAssertEqual(Die.d100, Die(sides: 100)!)
    }
}
