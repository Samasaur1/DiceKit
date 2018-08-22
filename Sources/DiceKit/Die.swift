public class Die {
    public let sides: Int
    public init(sides: Int) {
        self.sides = sides
    }
}

extension Die: Rollable {
    public func roll() -> Roll {
        return Roll(value: Random.random(max: sides))
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
