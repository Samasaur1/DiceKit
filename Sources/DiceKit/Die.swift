/// A representation of a single die.
///
/// It can be rolled using the `roll()` method, which will give a `Roll` result.
///
/// A `Die` object cannot change. Use the addition operators and the `Dice` class to represent more complex dice expressions.
///
/// - Author: Samasaur
public struct Die {
    /// The number of sides on this `Die`. This value does not need to be possible (for example, it can be 13), but it *does* need to be larger than 0.
    public let sides: Int
    /// Creates a new `Die` with the given number of sides.
    ///
    /// This initializer will fail if the number of sides is `<= 0`.
    ///
    /// - Parameter sides: The number of sides for this die.
    /// - Throws: An `Error.IllegalNumberOfSides` error when the number of sides is less than or equal to 0
    public init(sides: Int) throws {
        guard sides > 0 else {
            throw Error.illegalNumberOfSides(attempt: sides)
        }
        self.sides = sides
    }
    /// Creates a new `Die` from the given string in dice notation.
    ///
    /// You cannot have a negative die (`-d6`), a die with negative sides (`d-6`), or a die with 0 sides (`d0`). Because this is a `Die` initializer, you can only have one die (no `2d6`).
    ///
    /// - Parameter str: The string to convert from.
    /// - Throws: Numerous errors if the string is malformed or empty.
    public init(_ str: String) throws {
        if str.isEmpty {
            throw Error.emptyString
        }
        if str.isNumeric {
            guard let num = Int(str) else { throw Error.nonNumericString }
            guard num > 0 else { throw Error.illegalNumberOfSides(attempt: num) }
            self.sides = num
        } else if String(str.prefix(1)).lowercased() == "d" {
            let remaining = String(str.dropFirst())
            if remaining.isNumeric {
                guard let num = Int(remaining) else { throw Error.nonNumericString }
                guard num > 0 else { throw Error.illegalNumberOfSides(attempt: num) }
                self.sides = num
            } else {
                throw Error.nonNumericString
            }
        } else {
            throw Error.illegalString(string: str)
        }
    }
    /// Creates a new `Die` that is a copy of the given `Die`.
    ///
    /// - Parameter other: The other `Die` to copy.
    @available(*, deprecated, message: "CustomDie is now a struct; copying is not necessary")
    public init(copyOf other: Die) {
        sides = other.sides
    }

    private let __probabilities = LazyBox<Die, Chances> { d in
        var chances = Chances()
        let chance = try! Chance(1, outOf: d.sides) //swiftlint:disable:this force_try
        for i in 1...d.sides {
            chances[of: i] = chance
        }
        return chances
    }

    /// The probabilities of all possible rolls.
    ///
    /// - Since: 0.17.0
    public var probabilities: Chances {
        return __probabilities.value(input: self)
    }
}

extension Die: Rollable {
    /// Rolls this `Die` and returns the result as a `Roll`.
    ///
    /// This function returns a random integer in the range 1 to `sides`, inclusive (`[1, sides]`).
    ///
    /// - Returns: A random value from `1` to `sides`.
    public func roll() -> Roll {
        return Roll.random(in: 1...sides)
    }

    /// The minimum possible result from using the `roll()` method.
    ///
    /// This method simulates rolling a `1` on this die.
    ///
    /// - Since: 0.2.0
    public var minimumResult: Roll {
        return 1
    }

    /// The maximum possible result from using the `roll()` method.
    ///
    /// This method simulates rolling the maximum on this die.
    ///
    /// - Since: 0.2.0
    public var maximumResult: Roll {
        return sides
    }

    /// The exact (double) average result from using the `roll()` method.
    /// This is used in the Dice method to avoid rounding errors.
    ///
    /// - Since: 0.15.0
    public var doubleAverageResult: Double {
      return Double(sides + 1) / 2
    }

    /// The average result from using the `roll()` method.
    ///
    /// - Since: 0.15.0
    public var averageResult: Roll {
      return Int(doubleAverageResult.rounded())
    }

    /// Determines whether this `Die` can reach the target `Roll` using the given comparison type.
    ///
    /// - Parameters:
    ///   - target: The target to check reachibility for.
    ///   - comparisonType: The comparison to use when checking reachibility.
    /// - Returns: Whether or not this die can reach the target, using the given comparison.
    ///
    /// - Since: 0.15.0
    public func canReach(_ target: Roll, _ comparisonType: RollComparison) -> Bool {
        switch comparisonType {
        case .orHigher:
            return maximumResult >= target
        case .exactly:
            return minimumResult <= target && maximumResult >= target
        case .orLower:
            return minimumResult <= target
        }
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
    public func hash(into hasher: inout Hasher) {
        hasher.combine(sides)
    }
}

extension Die: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return "A \(sides)-sided die."
    }

    public var debugDescription: String {
        return "d\(sides)"
    }
}

public extension Die {
    /// Returns a copy of the given `Die` with separate memory.
    ///
    /// - Returns: A copy of the given `Die`, with the same number of sides, at a different memory location.
    @available(*, deprecated, message: "Die is now a struct; copying is not necessary")
    func copy() -> Die {
        return Die(copyOf: self)
    }
}

public extension Die {
    //swiftlint:disable force_try
    /// A four-sided die (`d4`).
    static var d4: Die {
        return try! Die(sides: 4)
    }
    /// A six-sided die (`d6`).
    static var d6: Die {
        return try! Die(sides: 6)
    }
    /// An eight-sided die (`d8`).
    static var d8: Die {
        return try! Die(sides: 8)
    }
    /// A ten-sided die (`d10`).
    static var d10: Die {
        return try! Die(sides: 10)
    }
    /// A twelve-sided die (`d12`).
    static var d12: Die {
        return try! Die(sides: 12)
    }
    /// A twenty-sided die (`d20`).
    static var d20: Die {
        return try! Die(sides: 20)
    }
    /// A one hundred-sided die (`d100`).
    static var d100: Die {
        return try! Die(sides: 100)
    }
    //swiftlint:enable force_try
}

public extension Die {
    static func + (lhs: Die, rhs: Die) -> Dice {
        return Dice(lhs, rhs)
    }
    static func + (lhs: Die, rhs: Int) -> Dice {
        return Dice(lhs, withModifier: rhs)
    }
    static func + (lhs: Int, rhs: Die) -> Dice {
        return Dice(rhs, withModifier: lhs)
    }
    static func + (lhs: Die, rhs: (die: Die, count: Int)) -> Dice {
        return lhs + (rhs.die * rhs.count)
    }
    static func + (lhs: (die: Die, count: Int), rhs: Die) -> Dice {
        return rhs + (lhs.die * lhs.count)
    }
    static func * (lhs: Die, rhs: Int) -> Dice {
        let dice = [Die].init(repeating: lhs, count: rhs)
        return Dice(dice: dice)
    }
    static func * (lhs: Int, rhs: Die) -> Dice {
        let dice = [Die].init(repeating: rhs, count: lhs)
        return Dice(dice: dice)
    }
}
