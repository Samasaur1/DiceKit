/// A representation of a weighted die; i.e. a die whose sides do not necessarily have the same chance of being rolled.
///
/// The chances of specific rolls are passed using a `Chances` object. It is recommended to create the object separately, because it is easier to manipulate the `Chance`s that way.
///
/// - Since: 0.16.0
/// - Author: Samasaur
public struct WeightedDie {
    /// The rolls and the chances of them occurring.
    public let chances: [Roll: Chance]
    /// Creates a new `WeightedDie` with the given rolls and chances of them occurring.
    ///
    /// - Parameter c: The rolls and the chances of them occurring.
    /// - Throws: `Error.emptyDictionary`
    public init(chances c: Chances) throws {
        chances = c.normalized.chances
        guard !chances.isEmpty else {
            throw Error.emptyDictionary
        }
    }

    /// The number of possible `Roll`s.
    public var sides: Int {
        return chances.values.count { $0.n > 0 }
    }

    /// Creates a new `WeightedDie` that is a copy of the given `WeightedDie`.
    ///
    /// - Parameter other: The other `WeightedDie` to copy.
    @available(*, deprecated, message: "CustomDie is now a struct; copying is not necessary")
    public init(copyOf other: WeightedDie) {
        self.chances = other.chances
    }

    private let __probabilities = LazyBox<WeightedDie, Chances> { wd in
        return Chances(chances: wd.chances)
    }

    /// The probabilities of all possible rolls.
    ///
    /// - Since: 0.17.0
    public var probabilities: Chances {
        return __probabilities.value(input: self)
    }
}

extension WeightedDie: Rollable {
    /// Rolls this `WeightedDie` and returns the result as a `Roll`.
    ///
    /// - Returns: One of the possible `Roll`s as given in the initializer, proportionally likely as given there.
    public func roll() -> Roll {
        let rand = Double.random(in: 0..<chances.map { $0.value.value }.sum)
        var baseline = 0.0
        for (roll, chance) in chances.mapValues({ $0.value }) {
            if rand < (chance + baseline) { return roll }
            baseline += chance
        }
        print("""

            <ERROR>

            The WeightedDie roll() function never returned, which shouldn't ever happen.
            Please create a new issue here: https://github.com/Samasaur1/DiceKit/issues/new
            and provide the following information:

            chances:        \(self.chances)
            rand:           \(rand)
            chances sum:    \(chances.map { $0.value.value }.sum)

            </ERROR>

            """, to: &STDERR)
        fatalError("The WeightedDie roll() function never returned\n\nSee above\n")
    }

    /// The minimum possible result from using the `roll()` method.
    public var minimumResult: Roll {
        return chances.filter { $0.value.n > 0 }.min { $0.key < $1.key }!.key
    }

    /// The maximum possible result from using the `roll()` method.
    public var maximumResult: Roll {
        return chances.filter { $0.value.n > 0 }.max { $0.key < $1.key }!.key
    }

    /// The exact (double) average result from using the `roll()` method.
    public var doubleAverageResult: Double {
        let m = 1.0 / chances.map { $0.value.value }.sum
        return chances.mapValues { $0.value * m }.map { Double($0.key) * $0.value }.sum

        //The above is a condensed version of the below

//        let sum = chances.map { $0.value.value }.sum
//        let multiplier = 1.0 / sum
//        let newChances = chances.mapValues { $0.value * multiplier } //this makes the chances add up to 1
//        let result = newChances.map { Double($0.key) * $0.value }.sum
//        return result
    }

    /// The average result from using the `roll()` method.
    public var averageResult: Roll {
        return Int(doubleAverageResult.rounded())
    }

    /// Determines whether this `WeightedDie` can reach the target `Roll` using the given comparison type.
    ///
    /// - Parameters:
    ///   - target: The target to check reachibility for.
    ///   - comparisonType: The comparison to use when checking reachibility.
    /// - Returns: Whether or not this WeightedDie can reach the target, using the given comparison.
    ///
    /// - Since: 0.15.0
    public func canReach(_ target: Roll, _ comparisonType: RollComparison) -> Bool {
        switch comparisonType {
        case .orHigher:
            return maximumResult >= target
        case .exactly:
            return (chances[target]?.n ?? 0) > 0
        case .orLower:
            return minimumResult <= target
        }
    }
}

extension WeightedDie: Equatable {
    public static func == (lhs: WeightedDie, rhs: WeightedDie) -> Bool {
        return lhs.chances == rhs.chances
    }
}

extension WeightedDie: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(chances)
    }
}

extension WeightedDie: Describable {
    public var description: String {
        return "A weighted die with chances: \(chances)"
    }

    public var debugDescription: String {
        return "A WeightedDie: \(chances)"
    }
}

public extension WeightedDie {
    /// Returns a copy of the given `WeightedDie` with separate memory.
    ///
    /// - Returns: A copy of the given `WeightedDie`, with the same number of sides, at a different memory location.
    @available(*, deprecated, message: "CustomDie is now a struct; copying is not necessary")
    func copy() -> WeightedDie {
        return self
    }
}

//public extension WeightedDie {
//    static func + (lhs: WeightedDie, rhs: WeightedDie) -> Dice {
//        return Dice(lhs, rhs)
//    }
//    static func + (lhs: WeightedDie, rhs: Int) -> Dice {
//        return Dice(lhs, withModifier: rhs)
//    }
//    static func + (lhs: Int, rhs: WeightedDie) -> Dice {
//        return Dice(rhs, withModifier: lhs)
//    }
//    static func + (lhs: WeightedDie, rhs: (WeightedDie: WeightedDie, count: Int)) -> Dice {
//        return lhs + (rhs.WeightedDie * rhs.count)
//    }
//    static func + (lhs: (WeightedDie: WeightedDie, count: Int), rhs: WeightedDie) -> Dice {
//        return rhs + (lhs.WeightedDie * lhs.count)
//    }
//    static func * (lhs: WeightedDie, rhs: Int) -> Dice {
//        let dice = [WeightedDie].init(repeating: lhs, count: rhs)
//        return Dice(dice: dice)
//    }
//    static func * (lhs: Int, rhs: WeightedDie) -> Dice {
//        let dice = [WeightedDie].init(repeating: rhs, count: lhs)
//        return Dice(dice: dice)
//    }
//}
