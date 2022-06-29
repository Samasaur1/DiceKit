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
    func roll(times: Int, _ returnType: MultipleRollResult) throws -> Roll

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
    func roll(times: Int, _ returnType: MultipleRollResult) throws -> Roll {
        guard times > 0 else {
            throw Error.insufficientRollsForCalculation(attempt: times, minimum: 1)
        }
        var rolls: [Roll] = []
        for _ in 0..<times {
            rolls.append(roll())
        }
        switch returnType {
        case .sum:
            return rolls.sum
        case .highest:
            guard let highest = rolls.max() else {
                fatalError("This should be unreachable")
            }
            return highest
        case .lowest:
            guard let lowest = rolls.min() else {
                fatalError("This should be unreachable")
            }
            return lowest
        case .outsides:
            guard times > 1 else {
                throw Error.insufficientRollsForCalculation(attempt: times, minimum: 2)
            }
            guard let min = rolls.min(), let max = rolls.max() else {
                fatalError("This should be unreachable")
            }
            return min + max
        case .dropHighest:
            guard times > 1 else { return 0 }
            guard let highest = rolls.max() else {
                fatalError("This should be unreachable")
            }
            return rolls.sum - highest
        case .dropLowest:
            guard times > 1 else { return 0 }
            guard let lowest = rolls.min() else {
                fatalError("This should be unreachable")
            }
            return rolls.sum - lowest
        case .dropOutsides:
            guard times >= 2 else {
                throw Error.insufficientRollsForCalculation(attempt: times, minimum: 2)
            }
            guard times > 2 else { return 0 }
            guard let min = rolls.min(), let max = rolls.max() else {
                fatalError("This should be unreachable")
            }
            return rolls.sum - (min + max)
        case .dropLow(let amountToDrop):
            guard times >= amountToDrop else {
                throw Error.insufficientRollsForCalculation(attempt: times, minimum: amountToDrop)
            }
            guard times > amountToDrop else { return 0 }
            let sorted = rolls.sorted(by: <)
            return sorted.dropFirst(amountToDrop).sum
        case .dropHigh(let amountToDrop):
            guard times >= amountToDrop else {
                throw Error.insufficientRollsForCalculation(attempt: times, minimum: amountToDrop)
            }
            guard times > amountToDrop else { return 0 }
            let sorted = rolls.sorted(by: >)
            return sorted.dropFirst(amountToDrop).sum
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
