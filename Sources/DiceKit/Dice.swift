public class Dice {
    public let dice: [Die]
    public let modifier: Int
    public init(_ dice: Die...) {
        self.dice = dice.sorted(by: >)
        self.modifier = 0
    }
    public init(dice: [Die]) {
        self.dice = dice.sorted(by: >)
        self.modifier = 0
    }
    public init(_ dice: Die..., withModifier modifier: Int) {
        self.dice = dice.sorted(by: >)
        self.modifier = modifier
    }
    public init(dice: [Die], withModifier modifier: Int) {
        self.dice = dice.sorted(by: >)
        self.modifier = modifier
    }
    public init(copyOf other: Dice) {
        dice = other.dice.map { $0.copy() }
        modifier = other.modifier
    }
}

extension Dice: Rollable {
    public func roll() -> Roll {
        var result: Roll = Roll(value: 0)
        for d in dice {
            result += d.roll()
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
        var diceRepeating: [Die: Int] = [:]
        for d in dice {
            diceRepeating[d] = (diceRepeating[d] ?? 0) + 1
        }
        for (die, count) in diceRepeating.sorted(by: { $0.key > $1.key }) {
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
        var diceRepeating: [Die: Int] = [:]
        for d in dice {
            diceRepeating[d] = (diceRepeating[d] ?? 0) + 1
        }
        for (die, count) in diceRepeating.sorted(by: { $0.key > $1.key }) {
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
        var dice = lhs.dice.map { $0.copy() }
        dice.append(rhs)
        return Dice(dice: dice)
    }
    public static func + (lhs: Die, rhs: Dice) -> Dice {
        var dice = rhs.dice.map { $0.copy() }
        dice.append(lhs)
        return Dice(dice: dice)
    }
    
    public static func + (lhs: Dice, rhs: Dice) -> Dice {
        let lhsDiceCopy = lhs.dice.map { $0.copy() }
        let rhsDiceCopy = rhs.dice.map { $0.copy() }
        return Dice(dice: lhsDiceCopy + rhsDiceCopy)
    }
    
    public static func + (lhs: Dice, rhs: Int) -> Dice {
        let dice = lhs.dice.map { $0.copy() }
        return Dice(dice: dice, withModifier: rhs)
    }
    public static func + (lhs: Int, rhs: Dice) -> Dice {
        let dice = rhs.dice.map { $0.copy() }
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
