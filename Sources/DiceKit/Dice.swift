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
}

extension Dice: Rollable {
    /// Rolls this `Dice` object.
    ///
    /// This function rolls every `Die` included in this `Dice` object, adds them together, adds the modifier (if any), and returns the result
    ///
    /// - Returns: The sum of the rolls of every `Die` in this `Dice` + the modifier.
    public func roll() -> Roll {
        var result: Roll = Roll(value: 0)
        for (die, count) in dice {
            for _ in 0..<count {
                result += die.roll()
            }
        }
        result += Roll(value: modifier)
        return result
    }
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
    ///     Dice(Die.d6, withModifier: 5).description // 1 six-sided die, with a modifier of 5.
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

extension Dice {
    /// Returns a copy of the given `Dice` with separate memory.
    ///
    /// - Returns: A copy of the given `Dice`, with the same information, at a different memory location.
    public func copy() -> Dice {
        return Dice(copyOf: self)
    }
}

extension Dice {
    public var minimum: Int {
        return numberOfDice + modifier
    }
}

extension Dice {
    public static func + (lhs: Dice, rhs: Die) -> Dice {
        var dice: [Die] = []
        for (d, c) in lhs.dice {
            for _ in 0..<c {
                dice.append(d.copy())
            }
        }
        dice.append(rhs)
        return Dice(dice: dice)
    }
    public static func + (lhs: Die, rhs: Dice) -> Dice {
        var dice: [Die] = []
        for (d, c) in rhs.dice {
            for _ in 0..<c {
                dice.append(d.copy())
            }
        }
        dice.append(lhs)
        return Dice(dice: dice)
    }
    
    public static func + (lhs: Dice, rhs: Dice) -> Dice {
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
        return Dice(dice: dice)
    }
    
    public static func + (lhs: Dice, rhs: Int) -> Dice {
        var dice: [Die] = []
        for (d, c) in lhs.dice {
            for _ in 0..<c {
                dice.append(d.copy())
            }
        }
        return Dice(dice: dice, withModifier: rhs)
    }
    public static func + (lhs: Int, rhs: Dice) -> Dice {
        var dice: [Die] = []
        for (d, c) in rhs.dice {
            for _ in 0..<c {
                dice.append(d.copy())
            }
        }
        return Dice(dice: dice, withModifier: lhs)
    }
    public static func - (lhs: Dice, rhs: Int) -> Dice {
        return lhs + (-rhs)
    }
}
extension Dice {
    public static func += (lhs: inout Dice, rhs: Dice) {
        lhs = lhs + rhs
    }
    public static func += (lhs: inout Dice, rhs: Die) {
        lhs = lhs + rhs
    }
    public static func += (lhs: inout Dice, rhs: Int) {
        lhs = lhs + rhs
    }
    public static func -= (lhs: inout Dice, rhs: Int) {
        lhs = lhs - rhs
    }
}
