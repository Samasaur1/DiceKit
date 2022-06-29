import Foundation

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
public enum Error: Swift.Error, Equatable {
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
    /// Attempted to perform a calculation but didn't perform enough rolls to do so.
    /// 
    /// This error was most likely thrown when calling `Rollable.roll(times:_:)`. If `times` is less than 1, this error will always be thrown. If `times` is one or greater, but not enough for the requested calculation (for example, if `times` is 1 and the calculation is `MultipleRollResult.outsides`), this error will also be thrown.
    ///
    /// Here is an example of how to use it:
    /// ```
    /// var times = -3
    /// while true {
    ///     do {
    ///         return try dice.roll(times: times, .dropLowest)
    ///     } catch let DiceKit.Error.insufficientRollsForCalculation(attempt, minimum) {
    ///         print("Could not perform calculation with \(attempt) roll(s); attempting with \(minimum)")
    ///         times = minimum
    ///     } catch {
    ///         fatalError("Crash on any other errors")
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - attempt: The number of rolls requested (usually the `times` paramter in the call that threw this error).
    ///   - minimum: The minimum number of rolls required in order to not throw this error. Call the same function, but increase the number of rolls requested to this number.
    case insufficientRollsForCalculation(attempt: Int, minimum: Int)

    public var localizedDescription: String {
        switch self {
        case .illegalNumberOfSides(let sides):
            return "A number of sides was passed that wasn't allowed (\(sides))."
        case .emptyString:
            return "An empty string was passed to a string parser that doesn't accept empty strings."
        case .nonNumericString:
            return "A string was passed with nonnumeric characters that weren't expected."
        case .illegalString(let str):
            return "An illegal string was passed (\"\(str)\")."
        case .divisionByZero:
            return "Zero was passed to something that would have divided by it."
        case .emptyDictionary:
            return "An empty dictionary was passed to something that needs a non-empty dictionary."
        case .negativeArgument:
            return "Arguments were passed that resulted in something being negative that needed to be positive."
        case .chanceOverOne:
            return "The chance of something happening was over 1, an impossibility."
        case let .insufficientRollsForCalculation(attempt, minimum):
            return "Attempted to perform a calculation with \(attempt) rolls but it needed \(minimum)."
        }
    }
}
extension Error: LocalizedError {
    public var errorDescription: String? {
        return self.localizedDescription
    }
}
