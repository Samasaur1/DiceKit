import XCTest
@testable import DiceKit

final class RollTests: XCTestCase {
    func testIntialization() {
        let negativeRoll = Roll(value: -1)
        let zeroRoll = Roll(value: 0)
        let positiveRoll = Roll(value: 1)
        XCTAssertNotNil(negativeRoll)
        XCTAssertNotNil(zeroRoll)
        XCTAssertNotNil(positiveRoll)
    }
    
    func testEquatable() {
        let _5 = Roll(value: 5)
        let _3 = Roll(value: 3)
        let r3 = Roll(value: 3)
        XCTAssertNotEqual(_5, _3)
        XCTAssertNotEqual(_5, r3)
        XCTAssertEqual(_3, r3)
    }
    
    func testComparable() {
        let _5 = Roll(value: 5)
        let _3 = Roll(value: 3)
        let r3 = Roll(value: 3)
        XCTAssert(_5 > _3)
        XCTAssertFalse(_3 > r3)
        XCTAssert(_3 >= r3)
        XCTAssert(_3 < _5)
        XCTAssert(_3 <= r3)
    }
    
    func testHashable() {
        let _5 = Roll(value: 5)
        let _3 = Roll(value: 3)
        let r3 = Roll(value: 3)
        XCTAssertNotEqual(_5.hashValue, _3.hashValue)
        XCTAssertEqual(_3.hashValue, r3.hashValue)
    }
    
    func testOperators() {
        let _6 = Roll(value: 6)
        let _5 = Roll(value: 5)
        let _3 = Roll(value: 3)
        let _2 = Roll(value: 2)
        XCTAssertEqual(_2 + _3, _5)
        XCTAssertEqual(_5 - _3, _2)
        XCTAssertEqual(_2 * _3, _6)
        XCTAssertEqual(_6 / _3, _2)
    }
    
    func testCompoundAssignmentOperators() {
        let _6 = Roll(value: 6)
        let _5 = Roll(value: 5)
        let _3 = Roll(value: 3)
        let _2 = Roll(value: 2)
        var mutable: Roll
        
        mutable = Roll(value: 1)
        mutable += _2
        XCTAssertEqual(mutable, _3)
        
        mutable = Roll(value: 7)
        mutable -= _5
        XCTAssertEqual(mutable, _2)
        
        mutable = Roll(value: 2) //This should be redundant, but just in case...
        mutable *= _3
        XCTAssertEqual(mutable, _6)
        
        mutable = Roll(value: 10) //See above
        mutable /= _2
        XCTAssertEqual(mutable, _5)
    }
}
