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
            rolls.remove(at: rolls.firstIndex(of: rolls.max()!)!)
            return rolls.sum
        case .dropLowest:
            guard rolls.count > 1 else { return 0 }
            rolls.remove(at: rolls.firstIndex(of: rolls.min()!)!)
            return rolls.sum
        case .dropOutsides:
            guard rolls.count > 2 else { return 0 }
            rolls.remove(at: rolls.firstIndex(of: rolls.max()!)!)
            rolls.remove(at: rolls.firstIndex(of: rolls.min()!)!)
            return rolls.sum
        case .dropLow(let amountToDrop):
            guard rolls.count >= amountToDrop else { return 0 }
            for _ in 0..<amountToDrop {
                rolls.remove(at: rolls.firstIndex(of: rolls.min()!)!)
            }
            return rolls.sum
        case .dropHigh(let amountToDrop):
            guard rolls.count >= amountToDrop else { return 0 }
            for _ in 0..<amountToDrop {
                rolls.remove(at: rolls.firstIndex(of: rolls.max()!)!)
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
