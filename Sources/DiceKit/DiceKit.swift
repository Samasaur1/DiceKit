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
}

public enum MultipleRollResult {
    case sum
    case highest
    case lowest
    case outsides
    case dropHighest
    case dropLowest
    case dropOutsides
    case dropLow(amountToDrop: Int)
    case dropHigh(amountToDrop: Int)
}

internal extension Array where Element == Roll {
    internal var sum: Roll {
        var total = 0
        for r in self {
            total += r
        }
        return total
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
