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
}




public struct Roll {
    let value: Int
}

extension Roll: Equatable {
    public static func == (lhs: Roll, rhs: Roll) -> Bool {
        return lhs.value == rhs.value
    }
}

extension Roll: Comparable {
    public static func < (lhs: Roll, rhs: Roll) -> Bool {
        return lhs.value < rhs.value
    }
}

extension Roll: Hashable {
    public var hashValue: Int {
        return value
    }
}

extension Roll: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return "A roll with a value of \(value)"
    }
    
    public var debugDescription: String {
        return "roll(value: \(value))"
    }
}

extension Roll {
    public static func + (lhs: Roll, rhs: Roll) -> Roll {
        return Roll(value: lhs.value + rhs.value)
    }
    public static func - (lhs: Roll, rhs: Roll) -> Roll {
        return Roll(value: max(lhs.value - rhs.value, 0))
    }
    public static func * (lhs: Roll, rhs: Roll) -> Roll {
        return Roll(value: max(lhs.value * rhs.value, 0))
    }
    public static func / (lhs: Roll, rhs: Roll) -> Roll {
        return Roll(value: max(lhs.value / rhs.value, 0))
    }
}

extension Roll {
    public static func += (lhs: inout Roll, rhs: Roll) {
        lhs = lhs + rhs
    }
    public static func -= (lhs: inout Roll, rhs: Roll) {
        lhs = lhs - rhs
    }
    public static func *= (lhs: inout Roll, rhs: Roll) {
        lhs = lhs * rhs
    }
    public static func /= (lhs: inout Roll, rhs: Roll) {
        lhs = lhs / rhs
    }
}
