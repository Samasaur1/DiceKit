public struct Negation {
    fileprivate let rollable: Rollable

    public init(_ r: Rollable) {
        rollable = r
    }

    private let __probabilities = LazyBox<Negation, Chances> { n in
        return Chances(chances: n.rollable.probabilities.dict.mapKeys { -$0 })
    }
}

extension Negation: Rollable {
    public func roll() -> Roll {
        return -rollable.roll()
    }

    public var minimumResult: Roll {
        return -rollable.maximumResult
    }

    public var maximumResult: Roll {
        return -rollable.minimumResult
    }

    public var averageResult: Roll {
        return -rollable.averageResult
    }

    public func canReach(_ target: Roll, _ comparisonType: RollComparison) -> Bool {
        switch comparisonType {
        case .orLower:
            return rollable.canReach(-target, .orHigher)
        case .exactly:
            return rollable.canReach(target, .exactly)
        case .orHigher:
            return rollable.canReach(-target, .orLower)
        }
    }

    public var probabilities: Chances {
        return __probabilities.value(input: self)
    }
}

public prefix func - (rhs: Rollable) -> Rollable {
    if let neg = rhs as? Negation {
        return neg.rollable
    }
    return Negation(rhs)
}
