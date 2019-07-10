/// A struct that represents the chance or probability of something happening.
///
/// Chances are stored as fractions, and the constructors that take decimal values use some algorithm off of StackOverflow to convert them to fractions.
///
/// - Since: 0.16.0
/// - Author: Samasaur
public struct Chance {
    /// The numerator of the fraction
    public let n: Int
    /// The denominator of the fraction
    public let d: Int
    /// The decimal representation of the fraction.
    public var value: Double {
        return Double(n) / Double(d)
    }
    /// The fraction as a tuple (numerator, denominator).
    public var fraction: (Int, Int) {
        return (n, d)
    }

    /// Creates a new `Chance` object of the fraction form 1/d.
    ///
    /// - Parameter d: The denominator of the fraction.
    /// - Returns: A new fraction with the given denominator and a numerator of 1.
    /// - Throws: `Error.divisionByZero`, `Error.negativeArgument`, or `Error.chanceOverOne`
    public static func oneOut(of d: Int) throws -> Chance {
        return try self.init(1, outOf: d)
    }

    /// Creates a new `Chance` object of the fraction form n/d.
    ///
    /// - Parameters:
    ///   - n: The numerator of the fraction.
    ///   - d: The denominator of the fraction.
    /// - Throws: `Error.divisionByZero`, `Error.negativeArgument`, or `Error.chanceOverOne`
    public init(_ n: Int, outOf d: Int) throws {
        guard d != 0 else {
            throw Error.divisionByZero
        }
        if n != 0 {
            guard n.signum() == d.signum() else {
                throw Error.negativeArgument
            }
        }
        guard n <= d else {
            throw Error.chanceOverOne
        }
        let simplify: (Int, Int) -> (n: Int, d: Int) = { top, bottom in
            //swiftline:disable all
            var x = top
            var y = bottom
            while y != 0 {
                let buffer = y
                y = x % y
                x = buffer
            }
            let hcfVal = x
            let newTopVal = top / hcfVal
            let newBottomVal = bottom / hcfVal
            //swiftlint:enable all
            return(newTopVal, newBottomVal)
        }
        let simple = simplify(n, d)
        self.n = simple.n
        self.d = simple.d
    }

    /// Creates a new `Chance` object of the fraction form 1/d.
    ///
    /// - Parameter d: The denominator of the fraction.
    /// - Throws: `Error.divisionByZero`, `Error.negativeArgument`, or `Error.chanceOverOne`
    public init(oneOutOf d: Int) throws {
        try self.init(1, outOf: d)
    }

    /// Creates a new `Chance` object approximating the given decimal.
    ///
    /// This uses some algorithm off of StackOverflow.
    ///
    /// - Parameter x0: The decimal value to convert to a fraction.
    /// - Throws: `Error.negativeArgument` or `Error.chanceOverOne`
    public init(approximating x0: Double) throws {
        guard x0 != 0 else {
            try self.init(0, outOf: 1)
            return
        }
        guard x0 > 0 else {
            throw Error.negativeArgument
        }
        guard x0 != 1 else {
            try self.init(oneOutOf: 1)
            return
        }
        guard x0 < 1 else {
            throw Error.chanceOverOne
        }
        //swiftlint:disable all
        let eps = 1.0E-6
        var x = x0
        var a = x.rounded(.down)
        var (h1, k1, h, k) = (1, 0, Int(a), 1)

        while x - a > eps * Double(k) * Double(k) {
            x = 1.0 / (x - a)
            a = x.rounded(.down)
            (h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
        }
        //swiftlint:enable all
        try self.init(h, outOf: k)
    }

    //swiftlint:disable force_try
    /// A `Chance` of zero.
    public static let zero = try! Chance(0, outOf: 1)
    /// A `Chance` of one.
    public static let one = try! Chance(1, outOf: 1)
    //swiftlint:enable force_try
}
extension Chance: Equatable {
    public static func == (lhs: Chance, rhs: Chance) -> Bool {
        return lhs.fraction == rhs.fraction
    }
}
extension Chance: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(n)
        hasher.combine(d)
    }
}
extension Chance: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = Double
    /// Creates a new `Chance` object approximating the given decimal. There is no error-checking!
    ///
    /// This function calls `init(approximating:)`, and will crash if that function throws an error.
    ///
    /// - Parameter value: The decimal value to convert to a fraction.
    public init(floatLiteral value: Chance.FloatLiteralType) {
        do {
            try self.init(approximating: value)
        } catch let err as Error {
            print(err, to: &STDERR)
            self = .zero
        } catch let err {
            print("""

                <ERROR>

                Initializing a Chance using init(floatLiteral:) threw a non-DiceKit error, which shouldn't ever happen.
                Please create a new issue here: https://github.com/Samasaur1/DiceKit/issues/new
                and provide the following information:

                floatLiteral:   \(value)
                err:            \(err)

                </ERROR>

                """, to: &STDERR)
            fatalError("Non-DiceKit error came back from Chance.init(approximating:)\n\nSee above\n")
        }
    }
}
public extension Chance {
    /// The greatest common divisor/factor of two integers.
    ///
    /// - Parameters:
    ///   - a: The first integer.
    ///   - b: The second integer.
    /// - Returns: The greatest common divisor of the two integers.
    ///
    /// - Since: 0.17.0
    static func gcd(_ a: Int, _ b: Int) -> Int {
        var a = abs(a)
        var b = abs(b)
        if b > a {
            swap(&a, &b)
        }
        while b != 0 {
            (a, b) = (b, a % b)
        }
        return abs(a)
    }

    /// The least/lowest common multiple of two integers.
    ///
    /// - Parameters:
    ///   - a: The first integer.
    ///   - b: The second integer.
    /// - Returns: The lowest common multiple of the two integers.
    ///
    /// - Since: 0.17.0
    static func lcm(_ a: Int, _ b: Int) -> Int {
        return abs(a * b) / gcd(a, b)
    }

    /// Adds two `Chance` instances together.
    ///
    /// - Parameters:
    ///   - lhs: The augend (first summand).
    ///   - rhs: The addend (second summand).
    /// - Returns: The sum of the two `Chance` instances.
    ///
    /// - Since: 0.17.0
    static func + (lhs: Chance, rhs: Chance) -> Chance {
        let lcm = Chance.lcm(lhs.d, rhs.d)
        let lnum = lhs.n * lcm / lhs.d
        let rnum = rhs.n * lcm / rhs.d
        return (try? .init(lnum + rnum, outOf: lcm)) ?? .one
    }

    /// Subtracts one `Chance` instance from another.
    ///
    /// - Parameters:
    ///   - lhs: The minuend (the value to be subtracted from).
    ///   - rhs: The subtrahend (the value to subtract).
    /// - Returns: The difference of the two values.
    ///
    /// - Since: 0.17.0
    static func - (lhs: Chance, rhs: Chance) -> Chance {
        let lcm = Chance.lcm(lhs.d, rhs.d)
        let lnum = lhs.n * lcm / lhs.d
        let rnum = rhs.n * lcm / rhs.d
        return (try? .init(lnum - rnum, outOf: lcm)) ?? .zero
    }

    /// Adds the two `Chance` instances and sets the left-hand instance to the sum.
    ///
    /// - Parameters:
    ///   - lhs: The summand that will be set to the sum.
    ///   - rhs: The summand that will not be set to the sum.
    ///
    /// - Since: 0.17.0
    static func += (lhs: inout Chance, rhs: Chance) {
        lhs = lhs + rhs //swiftlint:disable:this shorthand_operator
    }
}

fileprivate extension Dictionary.Values where Dictionary.Value == Chance {
    var sum: Chance {
        var total = Chance.zero
        for element in self {
            total += element
        }
        return total
    }
}

/// A struct that represents the chances of different `Roll`s happening.
///
/// - Since: 0.16.0
/// - Author: Samasaur
public struct Chances {
    /// Creates a new `Chances` object with no data.
    public init() {
        self.dict = [:]
    }
    /// Creates a new `Chances` object with the given chances.
    ///
    /// - Parameter chances: The rolls and the chances of them occurring.
    public init(chances: [Roll: Chance]) {
        self.dict = chances
    }
    /// Creates a new `Chances` object with the given chances.
    ///
    /// - Parameter chances: The rolls and the chances of them occurring.
    public init(chances: (Roll, Chance)...) {
        self.init(chances: chances)
    }
    /// Creates a new `Chances` object with the given chances.
    ///
    /// - Parameter chances: The rolls and the chances of them occurring.
    public init(chances: [(Roll, Chance)]) {
        self.dict = [:]
        for (roll, chance) in chances where chance.n > 0 {
            self.dict[roll] = chance
        }
    }
    /// The rolls and the chances of them occurring.
    internal var dict: [Roll: Chance]
    /// The chance of the given roll occurring.
    ///
    /// This subscript can be used to get or set the chance.
    ///
    /// - Parameter roll: The roll to query/set the chance of occurring.
    public subscript(of roll: Roll) -> Chance {
        get {
            return dict[roll] ?? Chance.zero
        }
        set {
            dict[roll] = newValue
        }
    }
    /// A normalized version of this `Chances` instance. The sum of the `Chance`s will be 1
    ///
    /// - Since: 0.17.0
    public var normalized: Chances {
        let sum = dict.values.sum.value
        guard sum != 0 else {
            return Chances()
        }
        let multiplier = 1.0 / sum
        return Chances(chances: dict.mapValues { Chance(floatLiteral: $0.value * multiplier) })
    }
}
extension Chances: Equatable {
    public static func == (lhs: Chances, rhs: Chances) -> Bool {
        return lhs.dict == rhs.dict
    }
}
extension Chances: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(dict)
    }
}

/// A representation of a weighted die; i.e. a die whose sides do not necessarily have the same chance of being rolled.
///
/// The chances of specific rolls are passed using a `Chances` object. It is recommended to create the object separately, because it is easier to manipulate the `Chance`s that way.
///
/// - Since: 0.16.0
/// - Author: Samasaur
public class WeightedDie {
    /// The rolls and the chances of them occurring.
    public let chances: [Roll: Chance]
    /// Creates a new `WeightedDie` with the given rolls and chances of them occurring.
    ///
    /// - Parameter c: The rolls and the chances of them occurring.
    /// - Throws: `Error.emptyDictionary`
    public init(chances c: Chances) throws {
        chances = c.normalized.dict
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
    public init(copyOf other: WeightedDie) {
        chances = other.chances
    }

    /// The probabilities of all possible rolls.
    ///
    /// - Since: 0.17.0
    public lazy var probabilities: Chances = {
        return Chances(chances: chances)
    }()
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

extension WeightedDie: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return "A weighted die."
    }

    public var debugDescription: String {
        return "A WeightedDie"
    }
}

public extension WeightedDie {
    /// Returns a copy of the given `WeightedDie` with separate memory.
    ///
    /// - Returns: A copy of the given `WeightedDie`, with the same number of sides, at a different memory location.
    func copy() -> WeightedDie {
        return WeightedDie(copyOf: self)
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
