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

extension Chances: Describable {
    public var description: String {
        return "A Chances object with chances \(dict.description)"
    }

    public var debugDescription: String {
        return "Chances(\(dict.debugDescription))"
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
