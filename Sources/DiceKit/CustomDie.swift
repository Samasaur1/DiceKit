#if swift(>=4.2)
#else
import Foundation
#endif

/// A class that masks a side, returning a custom value in lieu of a number.
public class DieSide<OutputType: Hashable>: Hashable {//If not Hashable, ensure it is at least Equatable.
    
    /// Create a new DieSide with the given value.
    ///
    /// - Parameter value: The value that this DieSide will return when rolled.
    public init(_ value: OutputType) {
        self.value = value
    }
    
    /// The value that this DieSide will return when rolled.
    public let value: OutputType
    
    //MARK: Equatable & Hashable
    
    public static func == (lhs: DieSide, rhs: DieSide) -> Bool {
        guard type(of: lhs.value) == type(of: rhs.value) else {
            return false
        }
        return lhs.value == rhs.value
    }
    
    #if swift(>=4.2)
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
    #else
    public var hashValue: Int {
        return value.hashValue
    }
    #endif
}

/// A class that allows for dice with custom sides instead of numbers.
///
/// This class wraps a `Die` instance, and when `roll()` is called on this, it calls the Die's `roll()` method and maps the output to one of the `DieSide`s passed to the initializer.
public class CustomDie<Output: Hashable> {
    /// The `Die` that internally powers the `CustomDie`.
    private let die: Die
    /// A dictionary that maps the rolls of the die to the `DieSide`s passed to the initializer
    public private(set) var sides: [Roll: DieSide<Output>]
    
    /// Creates a new `CustomDie`, replacing one side with a new one.
    ///
    /// - Parameters:
    ///   - side: The side to replace.
    ///   - newSide: The side to replace it with.
    /// - Returns: A new `CustomDie`, after the first side has been replaced with the second.
    public func replacing(_ side: DieSide<Output>, with newSide: DieSide<Output>) -> CustomDie<Output> {
        let newSides = sides.mapValues { ds in
            return ds == side ? newSide : ds
        }
        return CustomDie(sides: [DieSide<Output>](newSides.values))!
    }
    
    /// Creates a new `CustomDie` with the given sides.
    ///
    /// - Parameter sidesArr: The sides of the die.
    public init?(sides sidesArr: [DieSide<Output>]) {
        guard sidesArr.count > 0 else {
            return nil
        }
        var sidesDict: [Roll: DieSide<Output>] = [:]
        for (i, el) in sidesArr.enumerated() {
            sidesDict[i + 1] = el
        }
        die = Die(sides: sidesArr.count)!
        sides = sidesDict
        
    }
    
    /// Creates a new `CustomDie` that is a copy of the given `CustomDie`.
    ///
    /// - Parameter other: The other `CustomDie` to copy.
    public init(copyOf other: CustomDie) {
        die = other.die.copy()
        sides = other.sides
    }
}

extension CustomDie {
    /// Rolls this `CustomDie`.
    ///
    /// - Returns: One of the `DieSide`s passed to the initializer.
    public func roll() -> DieSide<Output> {
        return sides[die.roll()]!
        
        /*
         This is just here for posterity, but look at this! It has no warnings! Plus, code folding!
         
        return sides[die.roll()] ?? { () -> DieSide in
            fatalError("A CustomDie had a sides dictionary that didn't have values for every possible roll.")
        }() //fatalError message, tricky to suppress warnings.
         
        */
    }
}

extension CustomDie: Equatable {
    public static func == (lhs: CustomDie, rhs: CustomDie) -> Bool {
        guard lhs.die == rhs.die else {
            return false
        }
        guard lhs.sides.count == rhs.sides.count else {
            return false
        }
        var lhsArr: [Bool] = .init(repeating: false, count: lhs.sides.count + 1)
        lhsArr[0] = true
        var rhsArr: [Bool] = .init(repeating: false, count: lhs.sides.count + 1)
        rhsArr[0] = true
        for (k, v) in lhs.sides {
            var matched = false
            for (k2, v2) in rhs.sides {
                if v == v2 {
                    if !lhsArr[k] && !rhsArr[k2] {
                        lhsArr[k] = true
                        rhsArr[k2] = true
                        matched = true
                        break
                    }
                }
            }
            if !matched {
                return false
            }
        }
        return true
    }
}

extension CustomDie: Hashable {
    #if swift(>=4.2)
    public func hash(into hasher: inout Hasher) {
        hasher.combine(sides)
        hasher.combine(die)
    }
    #else
    public var hashValue: Int {
        return sides.hashValue ^ die.hashValue
    }
    #endif
}

extension CustomDie: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return "A CustomDie."
    }
    
    public var debugDescription: String {
        return "A CustomDie"
    }
}

extension CustomDie {
    /// Returns a copy of the given `CustomDie` with separate memory.
    ///
    /// - Returns: A copy of the given `CustomDie`, with the same number of sides and `DieSide`s, at a different memory location.
    public func copy() -> CustomDie {
        return CustomDie(copyOf: self)
    }
}
