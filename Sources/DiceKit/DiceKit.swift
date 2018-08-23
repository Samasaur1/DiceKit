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

public protocol Rollable {
    func roll() -> Roll
}

public func + (lhs: Die, rhs: Die) -> Dice {
    return Dice(lhs, rhs)
}

