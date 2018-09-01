/// The result of a roll.
///
/// This is a struct returned from `Rollable` objects. It contains a single property, called `value`, which is the result of the roll.
///
/// - Author: Samasaur
public struct Roll {
    /// The result of the roll.
    public let value: Int
    
    /// Creates a `Roll` object with the specified value.
    ///
    /// - Parameter value: The value of this roll.
    public init(value: Int) {
        self.value = value
    }
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
        return Roll(value: max(lhs.value + rhs.value, 0))
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

extension Roll {
    /// A roll with a value of `0`
    public static var zero: Roll {
        return Roll(value: 0)
    }
}
