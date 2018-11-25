/// An object that is rollable. It must have a `roll()` method that returns a `Roll` object.
///
/// **Implemented By**
/// * `Die`
/// * `Dice`
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
    /// - Since: UPDATE_ME
    var averageResult: Roll { get }
    
    /// Determines whether or not this object can reach the target Roll, compared by the given comparison.
    ///
    /// - Parameters:
    ///   - target: The target to check reachibility for.
    ///   - comparisonType: The method of checking reachibility.
    /// - Returns: Whether or not this object can reach the target using the given method of comparison.
    func canReach(_ target: Roll, _ comparisonType: RollComparison) -> Bool
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
    case dropLow(amountToDrop: Int)
    /// Return the sum of everything except the given number of highest rolls.
    ///
    /// This removes the given number of rolls from the high end of the list, and then returns the sum of the remaining rolls. If `amountToDrop` is 0, it acts like `sum`; if it's 1, it acts like `dropHighest`.
    ///
    /// For example, if the rolls were 2, 8, 6, 4, and 10, and `amountToDrop` is 3, then the result would be 12 (2 + 4 + 6)
    case dropHigh(amountToDrop: Int)
}
#if swift(>=4.2)
/// An enum representing a comparison between two `Roll`s.
///
/// - Since: UPDATE_ME
public enum RollComparison: CaseIterable {
    /// If it is greater than or equal to the target.
    case orHigher
    /// If it is less than or equal to the target.
    case orLower
    /// If it is exactly equal to the target.
    case exactly
}
#else
/// An enum representing a comparison between two `Roll`s.
///
/// - Since: UPDATE_ME
public enum RollComparison {
    /// If it is greater than or equal to the target.
    case orHigher
    /// If it is less than or equal to the target.
    case orLower
    /// If it is exactly equal to the target.
    case exactly
}
#endif

internal extension Array where Element == Roll {
    internal var sum: Roll {
        var total = 0
        for r in self {
            total += r
        }
        return total
    }
}

internal extension String {
    internal var isNumeric: Bool {
        guard !self.isEmpty else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
}

public typealias DKDie = Die
public typealias DKDice = Dice
public typealias DKRoll = Roll
public typealias DKRollable = Rollable
public typealias DKMultipleRollResult = MultipleRollResult
/// The result of any `roll` method from any `Rollable` type.
///
/// - Since: 0.8.0
public typealias Roll = Int
