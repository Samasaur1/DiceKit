/// A struct that represents the chances of different `Roll`s happening.
///
/// - Since: 0.16.0
/// - Author: Samasaur
public struct Chances {
    /// Creates a new `Chances` object with no data.
    public init() {
        self.chances = [:]
    }
    /// Creates a new `Chances` object with the given chances.
    ///
    /// - Parameter chances: The rolls and the chances of them occurring.
    public init(chances: [Roll: Chance]) {
        self.chances = chances
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
        self.chances = [:]
        for (roll, chance) in chances where chance.n > 0 {
            self.chances[roll] = chance
        }
    }
    /// The rolls and the chances of them occurring.
    ///
    /// This is the property one should use in order to iterate through the possibilities, like so:
    ///
    /// ```
    /// let chances: Chances = getChancesFromSomewhereElse()
    /// let arr = chances.chances.sorted(by: { first, second in
    ///     first.key < second.key
    /// })
    /// for (roll, chance) in arr {
    ///     print("The chance of rolling a \(roll) is \(chance.n) out of \(chance.d)")
    /// }
    /// ```
    ///
    /// - Since: 0.21.0
    public private(set) var chances: [Roll: Chance]
    /// The chance of the given roll occurring.
    ///
    /// This subscript can be used to get or set the chance.
    ///
    /// - Parameter roll: The roll to query/set the chance of occurring.
    public subscript(of roll: Roll) -> Chance {
        get {
            return chances[roll] ?? Chance.zero
        }
        set {
            chances[roll] = newValue
        }
    }
    /// A normalized version of this `Chances` instance. The sum of the `Chance`s will be 1
    ///
    /// - Since: 0.17.0
    public var normalized: Chances {
        let sum = chances.values.sum.value
        guard sum != 0 else {
            return Chances()
        }
        let multiplier = 1.0 / sum
        return Chances(chances: chances.mapValues { Chance(floatLiteral: $0.value * multiplier) })
    }
}
extension Chances: Equatable {
    public static func == (lhs: Chances, rhs: Chances) -> Bool {
        return lhs.chances == rhs.chances
    }
}
extension Chances: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(chances)
    }
}

extension Chances: Describable {
    public var description: String {
        return "A Chances object with chances \(chances.description)"
    }

    public var debugDescription: String {
        return "Chances(\(chances.debugDescription))"
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
