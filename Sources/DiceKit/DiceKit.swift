import Foundation

/// A function that returns a random number from `min` (inclusive) to `max` (exclusive).
///
/// - Parameters:
///   - min: The minimum Int that can be returned (inclusive).
///   - max: The maximum Int that can be returned (exclusive).
/// - Returns: A random Int in the range [min, max).
internal func random(min: Int = 0, max: Int) -> Int {
    return Int(arc4random_uniform(UInt32(max - min))) + min
}

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
    
    /// The minimum possible result from using the `roll()` method.
    var minimumResult: Roll { get }
    
    /// The maximum possible result from using the `roll()` method.
    var maximumResult: Roll { get }
}
