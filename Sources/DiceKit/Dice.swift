public class Dice {
    public let dice: [Die]
    public init(_ dice: Die...) {
        self.dice = dice
    }
}

extension Dice: Rollable {
    public func roll() -> Roll {
        var result: Roll = Roll(value: 0)
        for d in dice {
            result += d.roll()
        }
        return result
    }
}

extension Dice: Equatable {
    public static func == (lhs: Dice, rhs: Dice) -> Bool {
        return lhs.dice == rhs.dice
    }
}

//extension Dice: Comparable {
//    public static func < (lhs: Dice, rhs: Dice) -> Bool {
//        return lhs.sides < rhs.sides
//    }
//}

//extension Dice: Hashable {
//    public var hashValue: Int {
//        return sides
//    }
//
//
//}

extension Dice: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        var desc = ""
        for d in dice {
            if desc.isEmpty {
                desc += d.description
            } else {
                desc += ", \(d.description)"
            }
        }
        if desc.isEmpty {
            desc = "No dice."
        }
        return "\(desc.replacingOccurrences(of: ".", with: ""))."
    }
    
    public var debugDescription: String {
        var desc = ""
        for d in dice {
            if desc.isEmpty {
                desc += d.debugDescription
            } else {
                desc += ", \(d.debugDescription)"
            }
        }
        return desc
    }
}
