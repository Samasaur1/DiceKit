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
