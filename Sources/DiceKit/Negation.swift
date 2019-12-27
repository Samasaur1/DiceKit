public struct Negation {
    fileprivate let rollable: Rollable

    private init(_ r: Rollable) {
        rollable = r
    }

    public static func of(_ r: Rollable) -> Rollable {
        if let neg = r as? Negation {
            return neg.rollable
        }
        return Negation(r)
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
            return rollable.canReach(-target, .exactly)
        case .orHigher:
            return rollable.canReach(-target, .orLower)
        }
    }

    public var probabilities: Chances {
        return __probabilities.value(input: self)
    }
}
extension Negation: Equatable {
    public static func == (lhs: Negation, rhs: Negation) -> Bool {
        return lhs.rollable == rhs.rollable
    }
}

public prefix func - (rhs: Rollable) -> Rollable {
    return Negation.of(rhs)
}
