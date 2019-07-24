/// An object that is rollable. It must have a `roll()` method that returns a `Roll` object.
///
/// **Implemented By**
/// * `Die`
/// * `Dice`
/// * `WeightedDie`
///
/// - Author: Samasaur
public protocol Rollable {
    /// Rolls this object and returns the result.
    ///
    /// - Returns: The result of the roll.
    func roll() -> Roll

    /// Rolls this object the given number of times and returns the given result type.
    ///
    /// - Parameters:
    ///   - times: The number of times to roll.
    ///   - returnType: The type of result to return.
    /// - Returns: The type of result performed with the given number of rolls.
    ///
    /// - Since: 0.5.0
    func roll(times: Int, _ returnType: MultipleRollResult) -> Roll

    /// The minimum possible result from using the `roll()` method.
    ///
    /// - Since: 0.2.0
    var minimumResult: Roll { get }

    /// The maximum possible result from using the `roll()` method.
    ///
    /// - Since: 0.2.0
    var maximumResult: Roll { get }

    /// The average result from using the `roll()` method.
    ///
    /// - Since: 0.15.0
    var averageResult: Roll { get }

    /// Determines whether or not this object can reach the target Roll, compared by the given comparison.
    ///
    /// - Parameters:
    ///   - target: The target to check reachibility for.
    ///   - comparisonType: The method of checking reachibility.
    /// - Returns: Whether or not this object can reach the target using the given method of comparison.
    ///
    /// - Since: 0.15.0
    func canReach(_ target: Roll, _ comparisonType: RollComparison) -> Bool

    /// Determines the chance of rolling the target `Roll`, compared by the given comparison.
    ///
    /// - Parameters:
    ///   - target: The target to check the chance for.
    ///   - comparisonType: The method of comparison of which the chance of occurring is being returned.
    /// - Returns: The chance of rolling the target using the given method of comparison.
    ///
    /// - Since: 0.17.0
    func chance(of target: Roll, _ comparisonType: RollComparison) -> Chance

    /// Determines the chance of rolling in the given range.
    ///
    /// - Parameter range: The range to check.
    /// - Returns: The chance of rolling in the given range.
    ///
    /// - Since: 0.17.0
    func chance(of range: Range<Roll>) -> Chance

    /// Determines the chance of rolling in the given range.
    ///
    /// - Parameter range: The range to check.
    /// - Returns: The chance of rolling in the given range.
    ///
    /// - Since: 0.17.0
    func chance(of range: ClosedRange<Roll>) -> Chance

    /// Determines the chance of rolling in the given range.
    ///
    /// - Parameter range: The range to check.
    /// - Returns: The chance of rolling in the given range.
    ///
    /// - Since: 0.17.0
    func chance(of range: PartialRangeFrom<Roll>) -> Chance

    /// Determines the chance of rolling in the given range.
    ///
    /// - Parameter range: The range to check.
    /// - Returns: The chance of rolling in the given range.
    ///
    /// - Since: 0.17.0
    func chance(of range: PartialRangeUpTo<Roll>) -> Chance

    /// Determines the chance of rolling in the given range.
    ///
    /// - Parameter range: The range to check.
    /// - Returns: The chance of rolling in the given range.
    ///
    /// - Since: 0.17.0
    func chance(of range: PartialRangeThrough<Roll>) -> Chance

    /// The probabilities of all possible rolls.
    ///
    /// - Since: 0.17.0
    var probabilities: Chances { get }
}

public extension Rollable {
    /// Rolls this object the given number of times and returns the given result type.
    ///
    /// - Parameters:
    ///   - times: The number of times to roll.
    ///   - returnType: The type of result to return.
    /// - Returns: The type of result performed with the given number of rolls.
    ///
    /// - Since: 0.5.0
    func roll(times: Int, _ returnType: MultipleRollResult) -> Roll {
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
            guard rolls.count > 1 else { return 0 }
            rolls.remove(at: rolls.index(of: rolls.max()!)!)
            return rolls.sum
        case .dropLowest:
            guard rolls.count > 1 else { return 0 }
            rolls.remove(at: rolls.index(of: rolls.min()!)!)
            return rolls.sum
        case .dropOutsides:
            guard rolls.count > 2 else { return 0 }
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

    /// Determines the chance of rolling the target `Roll`, compared by the given comparison.
    ///
    /// - Parameters:
    ///   - target: The target to check the chance for.
    ///   - comparisonType: The method of comparison of which the chance of occurring is being returned.
    /// - Returns: The chance of rolling the target using the given method of comparison.
    ///
    /// - Since: 0.17.0
    func chance(of target: Roll, _ comparisonType: RollComparison) -> Chance {
        switch comparisonType {
        case .orLower:
            guard minimumResult <= target else {
                return Chance.zero
            }
            var sum = Chance.zero
            for i in minimumResult...target {
                sum += probabilities[of: i]
            }
            return sum
        case .exactly:
            return probabilities[of: target]
        case .orHigher:
            guard target <= maximumResult else {
                return Chance.zero
            }
            var sum = Chance.zero
            for i in target...maximumResult {
                sum += probabilities[of: i]
            }
            return sum
        }
    }

    /// Determines the chance of rolling in the given range.
    ///
    /// - Parameter range: The range to check.
    /// - Returns: The chance of rolling in the given range.
    ///
    /// - Since: 0.17.0
    func chance(of range: Range<Roll>) -> Chance {
        var sum = Chance.zero
        for i in range {
            sum += probabilities[of: i]
        }
        return sum
    }
    /// Determines the chance of rolling in the given range.
    ///
    /// - Parameter range: The range to check.
    /// - Returns: The chance of rolling in the given range.
    ///
    /// - Since: 0.17.0
    func chance(of range: ClosedRange<Roll>) -> Chance {
        var sum = Chance.zero
        for i in range {
            sum += probabilities[of: i]
        }
        return sum
    }
    /// Determines the chance of rolling in the given range.
    ///
    /// - Parameter range: The range to check.
    /// - Returns: The chance of rolling in the given range.
    ///
    /// - Since: 0.17.0
    func chance(of range: PartialRangeFrom<Roll>) -> Chance {
        return chance(of: range.lowerBound, .orHigher)
    }
    /// Determines the chance of rolling in the given range.
    ///
    /// - Parameter range: The range to check.
    /// - Returns: The chance of rolling in the given range.
    ///
    /// - Since: 0.17.0
    func chance(of range: PartialRangeUpTo<Roll>) -> Chance {
        return chance(of: range.upperBound, .orLower) - chance(of: range.upperBound, .exactly)
    }

    /// Determines the chance of rolling in the given range.
    ///
    /// - Parameter range: The range to check.
    /// - Returns: The chance of rolling in the given range.
    ///
    /// - Since: 0.17.0
    func chance(of range: PartialRangeThrough<Roll>) -> Chance {
        return chance(of: range.upperBound, .orLower)
    }
}

/// An enum representing the type of result to return from rolling multiple times.
///
/// - sum: Return the sum of all rolls.
/// - highest: Return the highest roll.
/// - lowest: Return the lowest roll.
/// - outsides: Return the sum of the highest and the lowest roll.
/// - dropHighest: Return the sum of everything but the highest roll.
/// - dropLowest: Return the sum of everything except the lowest roll.
/// - dropOutsides: Return the sum of everything except the highest and lowest rolls.
/// - dropLow: Return the sum of everything except the given number of lowest rolls.
/// - dropHigh: Return the sum of everything except the given number of highest rolls.
///
/// - Since: 0.5.0
public enum MultipleRollResult {
    /// Return the sum of all rolls.
    case sum
    /// Return the highest roll.
    case highest
    /// Return the lowest roll.
    case lowest
    /// Return the sum of the highest and the lowest roll.
    case outsides
    /// Return the sum of everything but the highest roll.
    case dropHighest
    /// Return the sum of everything except the lowest roll. This is used in Pathfinder character generation.
    case dropLowest
    /// Return the sum of everything except the highest and lowest rolls.
    case dropOutsides
    /// Return the sum of everything except the given number of lowest rolls.
    ///
    /// This removes the given number of rolls from the low end of the list, and then returns the sum of the remaining rolls. If `amountToDrop` is 0, it acts like `sum`; if it's 1, it acts like `dropLowest`.
    ///
    /// For example, if the rolls were 2, 8, 6, 4, and 10, and `amountToDrop` is 3, then the result would be 24 (10 + 8 + 6)
    ///
    /// - Parameter amountToDrop: The amount to drop from the low end of the rolls.
    case dropLow(amountToDrop: Int)
    /// Return the sum of everything except the given number of highest rolls.
    ///
    /// This removes the given number of rolls from the high end of the list, and then returns the sum of the remaining rolls. If `amountToDrop` is 0, it acts like `sum`; if it's 1, it acts like `dropHighest`.
    ///
    /// For example, if the rolls were 2, 8, 6, 4, and 10, and `amountToDrop` is 3, then the result would be 12 (2 + 4 + 6)
    ///
    /// - Parameter amountToDrop: The amount to drop from the high end of the rolls.
    case dropHigh(amountToDrop: Int)
}
/// An enum representing a comparison between two `Roll`s.
///
/// - Since: 0.15.0
public enum RollComparison: CaseIterable {
    /// If it is greater than or equal to the target.
    case orHigher
    /// If it is less than or equal to the target.
    case orLower
    /// If it is exactly equal to the target.
    case exactly
}

internal extension Array where Element == Roll {
    var sum: Roll {
        var total = 0
        for r in self {
            total += r
        }
        return total
    }
}

internal extension String {
    var isNumeric: Bool {
        guard !self.isEmpty else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
}

internal extension Array where Element == Double {
    var sum: Double {
        var total = 0.0
        for el in self {
            total += el
        }
        return total
    }
}

internal extension Sequence where Element: Equatable {
    var uniqueElements: [Element] {
        return self.reduce(into: []) { uniqueElements, element in
            if !uniqueElements.contains(element) {
                uniqueElements.append(element)
            }
        }
    }
}
#if !swift(>=5.1) //Can't use `#if swift(<5.1)` for earlier than Swift 5
internal extension Sequence {
    func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
        var count = 0
        for e in self {
            if try predicate(e) {
                count += 1
            }
        }
        return count
    }
}
#else
#error("Do we still need this?")
#endif

/// See `Die`.
public typealias DKDie = Die
/// See `Dice`.
public typealias DKDice = Dice
/// See `Roll`.
public typealias DKRoll = Roll
/// See `Rollable`.
public typealias DKRollable = Rollable
/// See `MultipleRollResult`.
public typealias DKMultipleRollResult = MultipleRollResult
/// The result of any `roll` method from any `Rollable` type.
///
/// - Since: 0.8.0
public typealias Roll = Int

/// An enum representing any error that could be thrown during the use of DiceKit.
///
/// - illegalNumberOfSides: A number of sides was passed that wasn't allowed.
/// - emptyString: An empty string was passed to a string parser that doesn't accept empty strings.
/// - nonNumericString: A string was passed with nonnumeric characters that weren't expected.
/// - illegalString: An illegal string was passed.
/// - divisionByZero: Zero was passed to something that would have divided by it.
/// - emptyDictionary: An empty dictionary was passed to something that needs a non-empty dictionary.
/// - negativeArgument: An argument passed was negative, and only positive ones are allowed.
/// - chanceOverOne: The chance of something happening was over 1, an impossibility.
///
/// - Since: 0.16.0
public enum Error: Swift.Error {
    /// A number of sides was passed that wasn't allowed.
    /// - Parameter attempt: The number of sides that was passed.
    case illegalNumberOfSides(attempt: Int)
    /// An empty string was passed to a string parser that doesn't accept empty strings.
    case emptyString
    /// A string was passed with nonnumeric characters that weren't expected.
    case nonNumericString
    /// An illegal string was passed.
    ///
    /// Generally, one of the other string-related errors will be thrown. This error will only be thrown if the others don't apply.
    ///
    /// - Parameter string: The string that was passed.
    case illegalString(string: String)
    /// Zero was passed to something that would have divided by it.
    case divisionByZero
    /// An empty dictionary was passed to something that needs a non-empty dictionary.
    case emptyDictionary
    /// Arguments were passed that resulted in something being negative that needed to be positive. This doesn't necessarily mean that the arguments passed in this case were negative, and it is possible to pass some negative arguments, as long as they cancel each other out. All this error means is that the result of a computation would have been negative.
    case negativeArgument
    /// The chance of something happening was over 1, an impossibility.
    ///
    /// This error was most likely thrown when creating a `Chance` instance. However, a `Chances` object can have `Chance`s that *sum* to over 1.
    case chanceOverOne
}
/// See `Error`.
public typealias DKError = DiceKit.Error
/// See `WeightedDie`.
public typealias DKWeightedDie = WeightedDie
/// See `Chance`.
public typealias DKChance = Chance
/// See `Chances`.
public typealias DKChances = Chances

import Foundation
internal struct FileHandleOutputStream: TextOutputStream {
    private let fileHandle: FileHandle
    let encoding: String.Encoding

    init(_ fileHandle: FileHandle, encoding: String.Encoding = .utf8) {
        self.fileHandle = fileHandle
        self.encoding = encoding
    }

    mutating func write(_ string: String) {
        if let data = string.data(using: encoding) {
            fileHandle.write(data)
        }
    }
}
internal var STDERR = FileHandleOutputStream(.standardError)
internal var STDOUT = FileHandleOutputStream(.standardOutput)
