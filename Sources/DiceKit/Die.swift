#if swift(>=4.2)
#else
import Foundation
#endif

/// A representation of a single die.
///
/// It can be rolled using the `roll()` method, which will give a `Roll` result.
///
/// A `Die` object cannot change. Use the addition operators and the `Dice` class to represent more complex dice expressions.
///
/// - Author: Samasaur
public class Die {
    #if os(Linux)
    private var initialized = false
    #endif
    /// The number of sides on this `Die`. This value does not need to be possible (for example, it can be 13), but it *does* need to be larger than 0.
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
    /// Rolls this `Die` and returns the result as a `Roll`.
    ///
    /// This function returns a random integer in the range 1 to `sides`, inclusive (`[1, sides]`).
    ///
    /// - Returns: A random value from `1` to `sides`.
    public func roll() -> Roll {
        #if swift(>=4.2)
        return Roll.random(in: 1...6)
        #else
        #if os(macOS)
        //macOS
        return Int(arc4random_uniform(UInt32(sides))) + 1
        #else
        //Linux
        if !initialized {
            srandom(UInt32(time(nil)))
            initialized = true
        }
        return (random() % sides) + 1
        #endif
        #endif
    }
    
    /// Rolls this Die the given number of times and returns the given result type.
    ///
    /// - Parameters:
    ///   - times: The number of times to roll.
    ///   - returnType: The type of result to return.
    /// - Returns: The type of result performed with the given number of rolls.
    ///
    /// - Since: 0.5.0
    public func roll(times: Int, _ returnType: MultipleRollResult) -> Roll {
        var rolls: [Roll] = []
        for _ in 0..<times {
            rolls.append(roll())
        }
        switch returnType {
        case .sum:
            return rolls.sum
        case .highest:
            return rolls.max() ?? 0
        case .lowest:
            return rolls.min() ?? 0
        case .outsides:
            return (rolls.min() ?? 0) + (rolls.max() ?? 0)
        case .dropHighest:
            guard !rolls.isEmpty else { return 0 }
            rolls.remove(at: rolls.index(of: rolls.max()!)!)
            return rolls.sum
        case .dropLowest:
            guard !rolls.isEmpty else { return 0 }
            rolls.remove(at: rolls.index(of: rolls.min()!)!)
            return rolls.sum
        case .dropOutsides:
            guard !rolls.isEmpty else { return 0 }
            rolls.remove(at: rolls.index(of: rolls.max()!)!)
            rolls.remove(at: rolls.index(of: rolls.min()!)!)
            return rolls.sum
        case .dropLow(let amountToDrop):
            guard rolls.count >= amountToDrop else { return 0 }
            for _ in 0..<amountToDrop {
                rolls.remove(at: rolls.index(of: rolls.min()!)!)
            }
            return rolls.sum
        case .dropHigh(let amountToDrop):
            guard rolls.count >= amountToDrop else { return 0 }
            for _ in 0..<amountToDrop {
                rolls.remove(at: rolls.index(of: rolls.max()!)!)
            }
            return rolls.sum
        }
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
  
    /// The exact (float) average result from using the `roll()` method.
    /// This is used in the Dice method to avoid rounding errors.
    ///
    /// - Since: UPDATE_ME
    public var floatAverageResult: Float {
      return Float(sides + 1) / 2
    }
  
    /// The average result from using the `roll()` method.
    ///
    /// - Since: UPDATE_ME
    public var averageResult: Roll {
      return   Int(floatAverageResult.rounded())
    }
    
    /// Determines whether this `Die` can reach the target `Roll` using the given comparison type.
    ///
    /// - Parameters:
    ///   - target: The target to check reachibility for.
    ///   - comparisonType: The comparison to use when checking reachibility.
    /// - Returns: Whether or not this die can reach the target, using the given comparison.
    ///
    /// - Since: UPDATE_ME
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
    #if swift(>=4.2)
    public func hash(into hasher: inout Hasher) {
        hasher.combine(sides)
    }
    #else
    public var hashValue: Int {
        return sides
    }
    #endif
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
    /// An eight-sided die (`d8`).
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
    public static func + (lhs: Die, rhs: (die: Die, count: Int)) -> Dice {
        return lhs + (rhs.die * rhs.count)
    }
    public static func + (lhs: (die: Die, count: Int), rhs: Die) -> Dice {
        return rhs + (lhs.die * lhs.count)
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
