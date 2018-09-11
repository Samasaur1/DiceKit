/// A representation of a single die.
///
/// It can be rolled using the `roll()` method, which will give a `Roll` result.
///
/// A `Die` object cannot change. Use the addition operators and the `Dice` class to represent more complex dice expressions.
///
/// - Author: Samasaur
public class Die {
    /// The number of sides on this `Die`.This value does not need to be possible (for example, it can be 13), but it *does* need to be larger than 0.
    public let sides: Int
    /// Creates a new `Die` with the given number of sides.
    ///
    /// This initializer will fail if the number of sides is `<= 0`.
    ///
    /// - Parameter sides: The number of sides for this die.
    public init?(sides: Int) {
        guard sides > 0 else {
            return nil
        }
        self.sides = sides
    }
    /// Creates a new `Die` that is a copy of the given `Die`.
    ///
    /// - Parameter other: The other `Die` to copy.
    public init(copyOf other: Die) {
        sides = other.sides
    }
}

extension Die: Rollable {
    /// Rolls this `Dice` object.
    ///
    /// This function rolls every `Die` included in this `Dice` object, adds them together, adds the modifier (if any), and returns the result
    ///
    /// - Returns: The sum of the rolls of every `Die` in this `Dice` + the modifier.
    /// Rolls this `Die` and returns the result as a `Roll`.
    ///
    /// This function returns a random integer in the range 1 to `sides`, inclusive (`[1, sides]`).
    ///
    /// - Returns: A random value from `1` to `sides`.
    public func roll() -> Roll {
        return Roll(value: random(max: sides) + 1)
    }
    
    /// The minimum possible result from using the `roll()` method.
    ///
    /// This method simulates rolling a `1` on this die.
    ///
    /// - Since: 0.2.0
    public var minimumResult: Roll {
        return Roll(value: 1)
    }
    
    /// The maximum possible result from using the `roll()` method.
    ///
    /// This method simulates rolling the maximum on this die.
    ///
    /// - Since: 0.2.0
    public var maximumResult: Roll {
        return Roll(value: sides)
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
        return "d\(sides)"
    }
}

extension Die {
    /// Returns a copy of the given `Die` with separate memory.
    ///
    /// - Returns: A copy of the given `Die`, with the same number of sides, at a different memory location.
    public func copy() -> Die {
        return Die(copyOf: self)
    }
}

extension Die {
    /// A four-sided die (`d4`).
    public static var d4: Die {
        return Die(sides: 4)!
    }
    /// A six-sided die (`d6`).
    public static var d6: Die {
        return Die(sides: 6)!
    }
    /// A eight-sided die (`d8`).
    public static var d8: Die {
        return Die(sides: 8)!
    }
    /// A ten-sided die (`d10`).
    public static var d10: Die {
        return Die(sides: 10)!
    }
    /// A twelve-sided die (`d12`).
    public static var d12: Die {
        return Die(sides: 12)!
    }
    /// A twenty-sided die (`d20`).
    public static var d20: Die {
        return Die(sides: 20)!
    }
    /// A one hundred-sided die (`d100`).
    public static var d100: Die {
        return Die(sides: 100)!
    }
}

extension Die {
    public static func + (lhs: Die, rhs: Die) -> Dice {
        return Dice(lhs, rhs)
    }
    public static func + (lhs: Die, rhs: Int) -> Dice {
        return Dice(lhs, withModifier: rhs)
    }
    public static func + (lhs: Int, rhs: Die) -> Dice {
        return Dice(rhs, withModifier: lhs)
    }
    public static func * (lhs: Die, rhs: Int) -> Dice {
        let dice = [Die].init(repeating: lhs, count: rhs)
        return Dice(dice: dice)
    }
    public static func * (lhs: Int, rhs: Die) -> Dice {
        let dice = [Die].init(repeating: rhs, count: lhs)
        return Dice(dice: dice)
    }
}
