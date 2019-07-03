/// A collection of `Die` objects and/or a modifier that can be rolled using the `roll()` method.
///
/// The properties of `Dice` objects are immutable; use the addition operators to combine them with other `Die` objects or modifiers. You can use compound assignment operators if you want, so long as you declare the `Dice` object as a `var` instead of a `let` constant.
///
/// - Author: Samasaur
public class Dice {
    /// The dice that make up this collection, along with how many times they appear.
    ///
    /// This `[Die: Int]` dictionary stores the types of dice that appear, paired with the number of times they appear. For example:
    ///
    ///     let dice1 = Dice(Die.d6)
    ///     dice1.dice // [d6: 1]
    ///
    ///     let dice2 = Dice(Die.d6, Die.d6, Die.d4)
    ///     dice2.dice // [d6: 2, d4: 1]
    ///
    /// To iterate through this dictionary, do the following:
    ///
    ///     let dice = Dice(Die.d6, Die.d6, Die.d4)
    ///     for (die, count) in dice.dice {
    ///         print("\(die.description) appears \(count) time(s)")
    ///
    /// Output:
    ///
    ///     A six-sided die appears 2 time(s)
    ///     A four-sided die appears 1 time(s)
    ///
    /// To add a die to the dictionary (only applicable if using a mutable imitiation):
    ///
    ///     let dice = Dice(Die.d6, Die.d6, Die.d4)
    ///     let dieToAdd = Die.d8
    ///     dice.dice[dieToAdd] = (dice.dice[dieToAdd] ?? 0) + 1
    ///     // dice.dice is [d6: 2, d8: 1, d4: 1]
    ///     let otherDie = Die.d4
    ///     dice.dice[otherDie] = (dice.dice[otherDie] ?? 0) + 1
    ///     // dice.dice is [d6: 2, d8: 1, d4: 2]
    ///
    /// To convert the dictionary to an array of `(Die, Int)` tuples, sorted by descending size of dice:
    ///
    ///     let dice = Dice(Die.d6, Die.d6, Die.d4)
    ///     let diceArray = dice.dice.sorted(by: { $0.key > $1.key })
    ///     // diceArray is [(d6, 2), (d4, 1)]
    ///
    /// To convert the dictionary to an array of `Die` objects, including duplicates:
    ///
    ///     let dice = Dice(Die.d6, Die.d6, Die.d4)
    ///     var diceArray: [Die] = []
    ///     for (die, count) in dice.dice {
    ///         for _ in 0..<count {
    ///             diceArray += die.copy()
    ///         }
    ///     }
    ///     // diceArray is [d6, d6, d4]
    public let dice: [Die: Int]
    /// The number of dice in this `Dice` instance.
    ///
    /// - Since: 0.2.0
    public var numberOfDice: Int {
        var c = 0
        for (_, count) in dice {
            c += count
        }
        return c
    }
    /// The modifier added or subtracted from these `Dice`
    ///
    /// This `Int` is added to the result whenever the `roll()` method is called.
    public let modifier: Int
    /// Creates a new `Dice` object with the specified dice.
    ///
    /// - Parameter dice: The dice to include in this `Dice` object.
    public init(_ dice: Die...) {
        var newDice: [Die: Int] = [:]
        for d in dice {
            newDice[d] = (newDice[d] ?? 0) + 1
        }
        self.dice = newDice
        self.modifier = 0
    }
    /// Creates a new `Dice` object with the specified dice.
    ///
    /// - Parameter dice: The dice to include in this `Dice` object.
    public init(dice: [Die]) {
        var newDice: [Die: Int] = [:]
        for d in dice {
            newDice[d] = (newDice[d] ?? 0) + 1
        }
        self.dice = newDice
        self.modifier = 0
    }
    /// Creates a new `Dice` object with the given number of the specified die. This is essentially identical to `Dice(copyOf: die * count)`, but is more efficient.
    ///
    /// - Parameters:
    ///   - die: The die to include in this `Dice` object.
    ///   - count: The number of times the specified die should appear.
    ///
    /// - Since: 0.6.0
    public init(_ die: Die, count: Int) {
        self.dice = [die: count]
        self.modifier = 0
    }
    /// Creates a new `Dice` object with the specified dice. They should be in a (die: Die, count: Int) form, with the die being the type of die to add, and the count being the number of times to add it.
    ///
    /// - Parameter dieIntTuples: The dice to add, in the form (dieType, count).
    ///
    /// - Since: 0.6.0
    public init(_ dieIntTuples: (die: Die, count: Int)...) {
        var newDice: [Die: Int] = [:]
        for (die, count) in dieIntTuples {
            newDice[die] = (newDice[die] ?? 0) + count
        }
        self.dice = newDice
        self.modifier = 0
    }
    /// Creates a new `Dice` object with the specified dice and modifier
    ///
    /// - Parameters:
    ///   - dice: The dice to include in this `Dice` object.
    ///   - modifier: The modifier to apply to every roll.
    public init(_ dice: Die..., withModifier modifier: Int) {
        var newDice: [Die: Int] = [:]
        for d in dice {
            newDice[d] = (newDice[d] ?? 0) + 1
        }
        self.dice = newDice
        self.modifier = modifier
    }
    /// Creates a new `Dice` object with the specified dice and modifier
    ///
    /// - Parameters:
    ///   - dice: The dice to include in this `Dice` object.
    ///   - modifier: The modifier to apply to every roll
    public init(dice: [Die], withModifier modifier: Int) {
        var newDice: [Die: Int] = [:]
        for d in dice {
            newDice[d] = (newDice[d] ?? 0) + 1
        }
        self.dice = newDice
        self.modifier = modifier
    }
    /// Creates a new `Dice` object with the given number of the specified die, along with the specified modifier. This is essentially identical to `Dice(copyOf: (die * count) + modifier)`, but is more efficient.
    ///
    /// - Parameters:
    ///   - die: The die to include in this `Dice` object.
    ///   - count: The number of times the specified die should appear.
    ///   - modifier: The modifier to apply to every roll.
    ///
    /// - Since: 0.6.0
    public init(_ die: Die, count: Int, withModifier modifier: Int) {
        self.dice = [die: count]
        self.modifier = modifier
    }
    /// Creates a new `Dice` object with the specified dice and modifier. The dice should be in a (die: Die, count: Int) form, with the die being the type of die to add, and the count being the number of times to add it.
    ///
    /// - Parameter dieIntTuples: The dice to add, in the form (dieType, count).
    ///   - modifier: The modifer to apply to every roll.
    ///
    /// - Since: 0.6.0
    public init(_ dieIntTuples: (die: Die, count: Int)..., withModifier modifier: Int) {
        var newDice: [Die: Int] = [:]
        for (die, count) in dieIntTuples {
            newDice[die] = (newDice[die] ?? 0) + count
        }
        self.dice = newDice
        self.modifier = modifier
    }

    //swiftlint:disable function_body_length

    /// Creates a new `Dice` object from the specified string in dice notation.
    ///
    /// You cannot have a negative die **AS A RESULT** (`-d6`), a die with negative sides (`d-6`), or a die with 0 sides (`d0`). You cannot have an unreal modifier or use any operator except for addition and subtraction.
    ///
    /// You can have `-d6`s in your string, so long as they cancel each other out so that the final result is at least `0d6`.
    ///
    /// - Parameter str: The string to convert.
    /// - Throws: An `Error.IllegalNumberOfSides` error when the number of sides is less than or equal to 0
    public init(_ str: String) throws {
        var dice: [Int: Int] = [:]
        var mods: [Int] = []

        let str = str.filter({ $0 != " " })

        guard Set(str).isSubset(of: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "+", "-", "D", "d"]) else {
            throw Error.illegalString(string: str)
        }

        let plusSplit = str.split(whereSeparator: { $0 == "+" })
        for positiveExp in plusSplit {
            let exp = positiveExp.split(whereSeparator: { $0 == "-" })
            if positiveExp.starts(with: "-") {
                for ex in exp {//negative
                    if String(ex).isNumeric {
                        mods.append(-Int(String(ex))!)
                    } else if ex.contains("D") || ex.contains("d") {
                        let d = ex.split(whereSeparator: { $0 == "d" || $0 == "D" })
                        if d.count == 1 {
                            let sides = Int(String(d.first!))!
                            dice[sides] = (dice[sides] ?? 0) - 1
                        } else if d.count == 2 {
                            let multiplier = Int(String(d.first!))!
                            let sides = Int(String(d.last!))!
                            dice[sides] = (dice[sides] ?? 0) - multiplier
                        } else { throw Error.illegalString(string: str) } //Too many "d"s (e.g. 3d4d6)
                    } else { throw Error.illegalString(string: str) } //non-numeric and not a d, so...
                }
            } else {
                let ex = String(exp.first!)//positive
                if ex.isNumeric {
                    mods.append(Int(ex)!)
                } else if ex.contains("D") || ex.contains("d") {
                    let d = ex.split(whereSeparator: { $0 == "d" || $0 == "D" })
                    if d.count == 1 {
                        let sides = Int(String(d.first!))!
                        dice[sides] = (dice[sides] ?? 0) + 1
                    } else if d.count == 2 {
                        let multiplier = Int(String(d.first!))!
                        let sides = Int(String(d.last!))!
                        dice[sides] = (dice[sides] ?? 0) + multiplier
                    } else { throw Error.illegalString(string: str) } //Too many "d"s (e.g. 3d4d6)
                } else { throw Error.illegalString(string: str) } //non-numeric and not a d, so...
                for ex in exp.dropFirst() {//negative
                    if String(ex).isNumeric {
                        mods.append(-Int(String(ex))!)
                    } else if ex.contains("D") || ex.contains("d") {
                        let d = ex.split(whereSeparator: { $0 == "d" || $0 == "D" })
                        if d.count == 1 {
                            let sides = Int(String(d.first!))!
                            dice[sides] = (dice[sides] ?? 0) - 1
                        } else if d.count == 2 {
                            let multiplier = Int(String(d.first!))!
                            let sides = Int(String(d.last!))!
                            dice[sides] = (dice[sides] ?? 0) - multiplier
                        } else { throw Error.illegalString(string: str) } //Too many "d"s (e.g. 3d4d6)
                    } else { throw Error.illegalString(string: str) } //non-numeric and not a d, so...
                }
            }
        }

        var tempDice: [Die: Int] = [:]
        for (d, c) in dice {
            if c < 0 {
                throw Error.illegalString(string: str)
            } else if c == 0 {
                continue
            }
            tempDice[try! Die(sides: d)] = c //swiftlint:disable:this force_try
        }
        self.dice = tempDice
        self.modifier = mods.sum
    }
    //swiftlint:enable function_body_length

    /// Creates a new `Dice` object that is a copy of the given `Dice` object.
    ///
    /// - Parameter other: The other `Dice` object to copy.
    public init(copyOf other: Dice) {
        var newDice: [Die: Int] = [:]
        for (d, c) in other.dice {
            newDice[d.copy()] = c
        }
        self.dice = newDice
        modifier = other.modifier
    }

    /// The probabilities of all possible rolls.
    ///
    /// - Since: 0.17.0
    public lazy var probabilities: Chances = {
        var chances = Chances()
        for i in minimumResult...maximumResult {
            chances[of: i] = calculateChance(of: i)
        }
        return chances
    }()
}

extension Dice: Rollable {
    /// Rolls this `Dice` object.
    ///
    /// This function rolls every `Die` included in this `Dice` object, adds them together, adds the modifier (if any), and returns the result
    ///
    /// - Returns: The sum of the rolls of every `Die` in this `Dice` + the modifier.
    public func roll() -> Roll {
        var result = 0
        for (die, count) in dice {
            for _ in 0..<count {
                result += die.roll()
            }
        }
        result += modifier
        return result
    }

    /// The minimum possible result from using the `roll()` method.
    ///
    /// This method simulates rolling a `1` on *every* die in this `Dice` object. It also includes the modifier, if applicable.
    ///
    /// - Since: 0.2.0
    public var minimumResult: Roll {
        return numberOfDice + modifier
    }

    /// The maximum possible result from using the `roll()` method.
    ///
    /// This method simulates rolling the maximum on every die in this `Dice` object. It also includes the modifier, if applicable.
    ///
    /// - Since: 0.2.0
    public var maximumResult: Roll {
        var total = modifier
        for (die, count) in dice {
            total += (die.sides * count)
        }
        return total
    }

    /// The average result from using the `roll()` method.
    /// It is calculated with double numbers to avoid rounding errors.
    ///
    /// - Since: 0.15.0
    public var averageResult: Roll {
      var doubleAverage: Double = 0
      for (die, count) in self.dice {
        doubleAverage += Double(count) * die.doubleAverageResult
      }
      let average = Int(doubleAverage.rounded())
      return average + self.modifier
    }

    /// Determines whether this `Dice` object can reach the target `Roll` using the given comparison type.
    ///
    /// - Parameters:
    ///   - target: The target to check reachibility for.
    ///   - comparisonType: The comparison to use when checking reachibility.
    /// - Returns: Whether or not this `Dice` object can reach the target, using the given comparison.
    ///
    /// - Since: 0.15.0
    public func canReach(_ target: Roll, _ comparisonType: RollComparison) -> Bool {
        switch comparisonType {
        case .orHigher:
            return maximumResult >= target
        case .exactly:
            if maximumResult < target {
                return false
            }
            if minimumResult > target {
                return false
            }
            return true
        case .orLower:
            return minimumResult <= target
        }
    }

    private func calculateChance(of target: Roll) -> Chance {
        guard canReach(target, .exactly) else {
            return .zero
        }
        let newTarget = target - modifier

        var sortedDice: [Die] = []
        for (die, count) in dice {
            for _ in 0..<count {
                sortedDice.append(die)
            }
        }
        sortedDice = sortedDice.sorted()

        guard sortedDice.count > 1 else { //canReach checks for >0
            return sortedDice[0].chance(of: newTarget, .exactly)
        }

        //determine number of ways to sum to newTarget
        //A "partition" is the number of ways to sum to n using positive integers where order doesn't matter
        //A "composition" is the number of ways to sum to n using positive integers where order does matter
        //We want a composition
        //        let partitions = Dice.getPartitions(n: newTarget).map { $0.filter { $0 > 0} }
        let partitions = Dice.getPartitions(ofSize: numberOfDice, forTarget: newTarget)
        var compositions: [[Int]] = []
        for partition in partitions {
            compositions += Dice.getPermutations(of: partition)
        }
        compositions = compositions.uniqueElements
        //compositions is now all possible ways, but they can't all be done with the dice we have.
        let num = compositions.filter { $0.count == numberOfDice }.filter { arr in
            for i in 0..<numberOfDice {
                guard sortedDice[i].canReach(arr[i], .exactly) else {
                    return false
                }
            }
            return true
        }

        var max = 1
        for (die, count) in dice {
            for _ in 0..<count {
                max *= die.sides
            }
        }

        return (try? .init(num.count, outOf: max)) ?? .zero
    }

    private static func getPartitions(ofSize size: Int, forTarget target: Int) -> [[Int]] {
        guard size > 0 else {
            return []
        }
        guard size <= target else {
            return []
        }
        if size == target {
            return [[Int].init(repeating: 1, count: size)]
        }
        if size == 1 {
            return [[target]]
        }

        var partitions: [[Int]] = []

        var p = [Int].init(repeating: 1, count: size)
        p[0] = target - size + 1
        partitions.append(p)
        for i in 1..<size {
            for part in partitions {
                p = part
                repeat {
                    p[i - 1] -= 1
                    p[i] += 1
                    partitions.append(p)
                } while p[i - 1] > p[i]
            }
        }

        return partitions
    }

    private static func getPermutations(of array: [Int]) -> [[Int]] {
        var permutations: [[Int]] = []
        func permuteWirth(_ a: [Int], _ n: Int) {
            if n == 0 {
                permutations.append(a)
            } else {
                var a = a
                permuteWirth(a, n - 1)
                for i in 0..<n {
                    a.swapAt(i, n)
                    permuteWirth(a, n - 1)
                    a.swapAt(i, n)
                }
            }
        }
        permuteWirth(array, array.count - 1)
        return permutations
    }

    //swiftlint:enable cyclomatic_complexity
}

extension Dice: Equatable {
    public static func == (lhs: Dice, rhs: Dice) -> Bool {
        guard lhs.dice == rhs.dice else {
            return false
        }
        guard lhs.modifier == rhs.modifier else {
            return false
        }
        return true
    }
}

extension Dice: CustomStringConvertible, CustomDebugStringConvertible {
    /// A description of this `Dice` object.
    ///
    ///     Dice().description // No dice, without a modifier.
    ///
    ///     Dice(Die.d6).description // 1 6-sided die, with no modifier.
    ///
    ///     Dice(Die.d6, Die.d6, Die.d4).description // 2 6-sided dice, 1 four-sided die, with no modifier.
    ///
    ///     Dice(withModifier: 5).description // A modifier of 5.
    ///
    ///     Dice(Die.d6, withModifier: 5).description // 1 6-sided die, with a modifier of 5.
    ///
    ///     Dice(Die.d6, Die.d6, Die.d4, withModifier: 5).description // 2 6-sided dice, 1 four-sided die, with a modifier of 5.
    public var description: String {
        var desc = ""
        for (die, count) in dice.sorted(by: { $0.key > $1.key }) {
            if desc.isEmpty {
                desc += "\(count) \(die.sides)-sided di\(count == 1 ? "e" : "ce")"
            } else {
                desc += ", \(count) \(die.sides)-sided di\(count == 1 ? "e" : "ce")"
            }
        }
        if modifier != 0 {
            if desc.isEmpty {
                desc = "A modifier of \(modifier)."
            } else {
                desc += ", with a modifier of \(modifier)."
            }
        } else {
            if desc.isEmpty {
                desc = "No dice, without a modifier."
            } else {
                desc += ", with no modifier."
            }
        }
        return desc
    }

    /// A short, debug-usable description of this `Dice` object.
    ///
    ///     Dice().debugDescription // 0
    ///
    ///     Dice(Die.d6).debugDescription // 1d6
    ///
    ///     Dice(Die.d6, Die.d6, Die.d4).debugDescription // 2d6 + 1d4
    ///
    ///     Dice(withModifier: 5).debugDescription // + 5
    ///
    ///     Dice(Die.d6, withModifier: 5).debugDescription // 1d6 + 5
    ///
    ///     Dice(Die.d6, Die.d6, Die.d4, withModifier: 5).debugDescription // 2d6 + 1d4 + 5
    public var debugDescription: String {
        var desc = ""
        for (die, count) in dice.sorted(by: { $0.key > $1.key }) {
            if desc.isEmpty {
                desc += "\(count)\(die.debugDescription)"
            } else {
                desc += " + \(count)\(die.debugDescription)"
            }
        }
        if modifier > 0 {
            if desc.isEmpty {
                desc = "+ \(modifier)"
            } else {
                desc += " + \(modifier)"
            }
        } else if modifier < 0 {
            if desc.isEmpty {
                desc = "- \(-modifier)"
            } else {
                desc += " - \(-modifier)"
            }
        } else {
            if desc.isEmpty {
                return "0"
            }
        }
        return desc
    }
}

public extension Dice {
    /// Returns a copy of the given `Dice` with separate memory.
    ///
    /// - Returns: A copy of the given `Dice`, with the same information, at a different memory location.
    func copy() -> Dice {
        return Dice(copyOf: self)
    }
}

public extension Dice {
    /// Adds some `Dice` and a `Die` together, creating a new `Dice` object.
    ///
    /// - Parameters:
    ///   - lhs: The dice to add.
    ///   - rhs: The die to add.
    /// - Returns: A new `Dice` object comprising of the `Die` and `Dice` added together.
    static func + (lhs: Dice, rhs: Die) -> Dice {
        var dice: [Die] = []
        for (d, c) in lhs.dice {
            for _ in 0..<c {
                dice.append(d.copy())
            }
        }
        dice.append(rhs)
        return Dice(dice: dice, withModifier: lhs.modifier)
    }
    /// Adds some `Dice` and a `Die` together, creating a new `Dice` object.
    ///
    /// - Parameters:
    ///   - lhs: The die to add.
    ///   - rhs: The dice to add.
    /// - Returns: A new `Dice` object comprising of the `Die` and `Dice` added together.
    static func + (lhs: Die, rhs: Dice) -> Dice {
        var dice: [Die] = []
        for (d, c) in rhs.dice {
            for _ in 0..<c {
                dice.append(d.copy())
            }
        }
        dice.append(lhs)
        return Dice(dice: dice, withModifier: rhs.modifier)
    }

    /// Adds some `Dice` together, creating a new `Dice` object.
    ///
    /// - Parameters:
    ///   - lhs: The first set of dice to add.
    ///   - rhs: The second set of dice to add.
    /// - Returns: A new `Dice` object comprising of the `Dice` added together.
    static func + (lhs: Dice, rhs: Dice) -> Dice {
        var dice: [Die] = []
        for (d, c) in lhs.dice {
            for _ in 0..<c {
                dice.append(d.copy())
            }
        }
        for (d, c) in rhs.dice {
            for _ in 0..<c {
                dice.append(d.copy())
            }
        }
        return Dice(dice: dice, withModifier: rhs.modifier + lhs.modifier)
    }

    /// Adds a modifier to a `Dice` object.
    ///
    /// - Parameters:
    ///   - lhs: The dice.
    ///   - rhs: The modifier to add.
    /// - Returns: A new `Dice` object comprising of the modifier added to the first dice.
    static func + (lhs: Dice, rhs: Int) -> Dice {
        var dice: [Die] = []
        for (d, c) in lhs.dice {
            for _ in 0..<c {
                dice.append(d.copy())
            }
        }
        return Dice(dice: dice, withModifier: lhs.modifier + rhs)
    }
    /// Adds a modifier to a `Dice` object.
    ///
    /// - Parameters:
    ///   - lhs: The modifier to add.
    ///   - rhs: The dice.
    /// - Returns: A new `Dice` object comprising of the modifier added to the first dice.
    static func + (lhs: Int, rhs: Dice) -> Dice {
        var dice: [Die] = []
        for (d, c) in rhs.dice {
            for _ in 0..<c {
                dice.append(d.copy())
            }
        }
        return Dice(dice: dice, withModifier: lhs + rhs.modifier)
    }
    /// Adds the given dice to the given `Dice` object.
    ///
    /// - Parameters:
    ///   - lhs: The `Dice` object.
    ///   - rhs: The dice to add, in `(Die, Int)` tuples.
    /// - Returns: A new `Dice` object comprising of the new dice added to the initial `Dice` object.
    static func + (lhs: Dice, rhs: (die: Die, count: Int)) -> Dice {
        return lhs + (rhs.die * rhs.count)
    }
    /// Adds the given dice to the given `Dice` object.
    ///
    /// - Parameters:
    ///   - lhs: The dice to add, in `(Die, Int)` tuples.
    ///   - rhs: The `Dice` object.
    /// - Returns: A new `Dice` object comprising of the new dice added to the initial `Dice` object.
    static func + (lhs: (die: Die, count: Int), rhs: Dice) -> Dice {
        return rhs + (lhs.die * lhs.count)
    }
    /// Subtracts a modifier from a `Dice` object.
    ///
    /// - Parameters:
    ///   - lhs: The dice.
    ///   - rhs: The modifier to subtract.
    /// - Returns: A new `Dice` object comprising of the modifier subtracted from the first dice.
    static func - (lhs: Dice, rhs: Int) -> Dice {
        return lhs + (-rhs)
    }
    /// Multiplies the given `Dice` object by the given multiplier.
    ///
    /// This multiplies the count of each type of die, and the multiplier:
    ///
    ///    let dice = Dice((Die.d6, 6), (Die.d4, 4), withModifier: 2)
    ///    let newDice = dice * 3
    ///    //newDice is now 18d6 + 12d4 + 6
    ///
    /// - Parameters:
    ///   - lhs: The `Dice` object to multiply.
    ///   - rhs: The multiplier.
    /// - Returns: A new `Dice` object comprising of the given dice multiplied by the multiplier
    static func * (lhs: Dice, rhs: Int) -> Dice {
        var dice = lhs.copy()
        for (die, count) in lhs.dice {
            dice += die * (count * (rhs - 1))
        }
        dice += lhs.modifier * (rhs - 1)
        return dice
    }
    /// Multiplies the given `Dice` object by the given multiplier.
    ///
    /// This multiplies the count of each type of die, and the multiplier:
    ///
    ///    let dice = Dice((Die.d6, 6), (Die.d4, 4), withModifier: 2)
    ///    let newDice = dice * 3
    ///    //newDice is now 18d6 + 12d4 + 6
    ///
    /// - Parameters:
    ///   - lhs: The multiplier.
    ///   - rhs: The `Dice` object to multiply.
    /// - Returns: A new `Dice` object comprising of the given dice multiplied by the multiplier
    static func * (lhs: Int, rhs: Dice) -> Dice {
        var dice = rhs.copy()
        for (die, count) in rhs.dice {
            dice += die * ((lhs - 1) * count)
        }
        dice += rhs.modifier * (lhs - 1)
        return dice
    }
}
public extension Dice {
    //swiftlint:disable shorthand_operator
    static func += (lhs: inout Dice, rhs: Dice) {
        lhs = lhs + rhs
    }
    static func += (lhs: inout Dice, rhs: Die) {
        lhs = lhs + rhs
    }
    static func += (lhs: inout Dice, rhs: Int) {
        lhs = lhs + rhs
    }
    static func += (lhs: inout Dice, rhs: (die: Die, count: Int)) {
        lhs = lhs + rhs
    }
    static func -= (lhs: inout Dice, rhs: Int) {
        lhs = lhs - rhs
    }
    static func *= (lhs: inout Dice, rhs: Int) {
        lhs = lhs * rhs
    }
    //swiftlint:enable shorthand_operator
}
