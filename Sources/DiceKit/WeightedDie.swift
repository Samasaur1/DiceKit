#if swift(>=4.2)
#else
import Foundation
#endif

public struct Chance {
    public let n: Int
    public let d: Int
    public var value: Double {
        return Double(n) / Double(d)
    }
    public var fraction: (Int, Int) {
        return (n, d)
    }
    
    public static func oneOut(of d: Int) throws -> Chance {
        return try self.init(1, outOf: d)
    }
    
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
        let simplify: (Int, Int) -> (n: Int, d: Int) = { (top, bottom) in
            var x = top
            var y = bottom
            while (y != 0) {
                let buffer = y
                y = x % y
                x = buffer
            }
            let hcfVal = x
            let newTopVal = top/hcfVal
            let newBottomVal = bottom/hcfVal
            return(newTopVal, newBottomVal)
        }
        let simple = simplify(n, d)
        self.n = simple.n
        self.d = simple.d
    }
    
    public init(oneOutOf d: Int) throws {
        try self.init(1, outOf: d)
    }
    
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
        let eps = 1.0E-6
        var x = x0
        var a = x.rounded(.down)
        var (h1, k1, h, k) = (1, 0, Int(a), 1)
        
        while x - a > eps * Double(k) * Double(k) {
            x = 1.0/(x - a)
            a = x.rounded(.down)
            (h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
        }
        try self.init(h, outOf: k)
    }
    
    public static let zero = try! Chance(0, outOf: 1)
    public static let one = try! Chance(1, outOf: 1)
}
extension Chance: Equatable {
    public static func == (lhs: Chance, rhs: Chance) -> Bool {
        return lhs.fraction == rhs.fraction
    }
}
extension Chance: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = Double
    public init(floatLiteral value: Chance.FloatLiteralType) {
        try! self.init(approximating: value)
    }
}

public struct Chances {
    public init() {
        self.dict = [:]
    }
    public init(chances: [Roll: Chance]) {
        self.dict = chances
    }
    public init(chances: [(Roll, Chance)]) {
        self.dict = [:]
        for (roll, chance) in chances {
            self.dict[roll] = chance
        }
    }
    internal var dict: [Roll: Chance]
    public subscript(of roll: Roll) -> Chance {
        get {
            return dict[roll] ?? Chance.zero
        }
        set {
            dict[roll] = newValue
        }
    }
}
extension Chances: Equatable {
    public static func == (lhs: Chances, rhs: Chances) -> Bool {
        return lhs.dict == rhs.dict
    }
}
public class WeightedDie {
    public let chances: [Roll: Chance]
    public init(chances c: Chances) throws {
        chances = c.dict
        guard !chances.isEmpty else {
            throw Error.emptyDictionary
        }
    }

    public var sides: Int {
        return chances.values.count { $0.n > 0 }
    }
    /// Creates a new `WeightedDie` that is a copy of the given `WeightedDie`.
    ///
    /// - Parameter other: The other `WeightedDie` to copy.
    public init(copyOf other: WeightedDie) {
        chances = other.chances
    }
}

extension WeightedDie: Rollable {
    public func roll() -> Roll {
        fatalError("Not implemented")
//        #if swift(>=4.2)
//        return Roll.random(in: 1...sides)
//        #else
//        #if os(macOS)
//        //macOS
//        return Int(arc4random_uniform(UInt32(sides))) + 1
//        #else
//        //Linux
//        if !DiceKit.initialized {
//            srandom(UInt32(time(nil)))
//            DiceKit.initialized = true
//        }
//        return (random() % sides) + 1
//        #endif
//        #endif
    }
    
    /// The minimum possible result from using the `roll()` method.
    ///
    /// - Since: 0.2.0
    public var minimumResult: Roll {
        return chances.filter { $0.value.n > 0 }.sorted { $0.key < $1.key }.first!.key
    }
    
    /// The maximum possible result from using the `roll()` method.
    ///
    /// - Since: 0.2.0
    public var maximumResult: Roll {
        return chances.filter { $0.value.n > 0 }.sorted { $0.key < $1.key }.last!.key
    }
    
    public var doubleAverageResult: Double {
        return Double(sides + 1) / 2//TODO: avg
    }
    
    public var averageResult: Roll {
        return Int(doubleAverageResult.rounded()) //TODO: avg
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

#if swift(>=4.2)
extension WeightedDie: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(chances)
    }
}
#endif

extension WeightedDie: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return "A weighted die."
    }
    
    public var debugDescription: String {
        return "A WeightedDie"
    }
}

extension WeightedDie {
    /// Returns a copy of the given `WeightedDie` with separate memory.
    ///
    /// - Returns: A copy of the given `WeightedDie`, with the same number of sides, at a different memory location.
    public func copy() -> WeightedDie {
        return WeightedDie(copyOf: self)
    }
}

//extension WeightedDie {
//    public static func + (lhs: WeightedDie, rhs: WeightedDie) -> Dice {
//        return Dice(lhs, rhs)
//    }
//    public static func + (lhs: WeightedDie, rhs: Int) -> Dice {
//        return Dice(lhs, withModifier: rhs)
//    }
//    public static func + (lhs: Int, rhs: WeightedDie) -> Dice {
//        return Dice(rhs, withModifier: lhs)
//    }
//    public static func + (lhs: WeightedDie, rhs: (WeightedDie: WeightedDie, count: Int)) -> Dice {
//        return lhs + (rhs.WeightedDie * rhs.count)
//    }
//    public static func + (lhs: (WeightedDie: WeightedDie, count: Int), rhs: WeightedDie) -> Dice {
//        return rhs + (lhs.WeightedDie * lhs.count)
//    }
//    public static func * (lhs: WeightedDie, rhs: Int) -> Dice {
//        let dice = [WeightedDie].init(repeating: lhs, count: rhs)
//        return Dice(dice: dice)
//    }
//    public static func * (lhs: Int, rhs: WeightedDie) -> Dice {
//        let dice = [WeightedDie].init(repeating: rhs, count: lhs)
//        return Dice(dice: dice)
//    }
//}
