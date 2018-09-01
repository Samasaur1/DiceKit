public class Dice {
    public let dice: [Die: Int]
    public let modifier: Int
    public init(_ dice: Die...) {
        var newDice: [Die: Int] = [:]
        for d in dice {
            newDice[d] = (newDice[d] ?? 0) + 1
        }
        self.dice = newDice
        self.modifier = 0
    }
    public init(dice: [Die]) {
        var newDice: [Die: Int] = [:]
        for d in dice {
            newDice[d] = (newDice[d] ?? 0) + 1
        }
        self.dice = newDice
        self.modifier = 0
    }
    public init(_ dice: Die..., withModifier modifier: Int) {
        var newDice: [Die: Int] = [:]
        for d in dice {
            newDice[d] = (newDice[d] ?? 0) + 1
        }
        self.dice = newDice
        self.modifier = modifier
    }
    public init(dice: [Die], withModifier modifier: Int) {
        var newDice: [Die: Int] = [:]
        for d in dice {
            newDice[d] = (newDice[d] ?? 0) + 1
        }
        self.dice = newDice
        self.modifier = modifier
    }
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
                desc += "A modifier of \(modifier)."
            } else {
                desc += " with a modifier of \(modifier)."
            }
        } else {
            if desc.isEmpty {
                desc = "No dice, without a modifier."
            } else {
                desc += " with no modifier."
            }
        }
        return desc
    }
    
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
            desc += " + \(modifier)"
        } else if modifier < 0 {
            desc += " - \(-modifier)"
        }
        return desc
    }
}

extension Dice {
    public func copy() -> Dice {
        return Dice(copyOf: self)
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
