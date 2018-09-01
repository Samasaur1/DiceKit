public class Die {
    public let sides: Int
    public init?(sides: Int) {
        guard sides > 0 else {
            return nil
        }
        self.sides = sides
    }
    public init(copyOf other: Die) {
        sides = other.sides
    }
}

extension Die: Rollable {
    public func roll() -> Roll {
        return Roll(value: random(max: sides) + 1)
    }
}

extension Die: Equatable {
    public static func == (lhs: Die, rhs: Die) -> Bool {
        return lhs.sides == rhs.sides
    }
}

extension Die: Comparable {
    public static func < (lhs: Die, rhs: Die) -> Bool {
        return lhs.sides < rhs.sides
    }
}

extension Die: Hashable {
    public var hashValue: Int {
        return sides
    }
}

extension Die: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return "A \(sides)-sided die."
    }
    
    public var debugDescription: String {
        return "\(sides)-sided-die"
    }
}

extension Die {
    public func copy() -> Die {
        return Die(copyOf: self)
    }
}

extension Die {
    public static var d4: Die {
        return Die(sides: 4)!
    }
    public static var d6: Die {
        return Die(sides: 6)!
    }
    public static var d8: Die {
        return Die(sides: 8)!
    }
    public static var d10: Die {
        return Die(sides: 10)!
    }
    public static var d12: Die {
        return Die(sides: 12)!
    }
    public static var d20: Die {
        return Die(sides: 20)!
    }
    public static var d100: Die {
        return Die(sides: 100)!
    }
}

extension Die {
    public static func + (lhs: Die, rhs: Die) -> Dice {
        return Dice(lhs, rhs)
    }
}
