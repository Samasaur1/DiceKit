/// A class that masks a side, returning a custom value in lieu of a number.
///
/// - Since: 0.16.0
/// - Author: Samasaur
public struct DieSide<OutputType: Hashable>: Hashable {//If not Hashable, ensure it is at least Equatable.

    /// Create a new DieSide with the given value.
    ///
    /// - Parameter value: The value that this DieSide will return when rolled.
    public init(_ value: OutputType) {
        self.value = value
    }

    /// The value that this DieSide will return when rolled.
    public let value: OutputType

    public static func == (lhs: DieSide, rhs: DieSide) -> Bool { //IMPORTANT NOTE: THIS DOES NOT ACCEPT `DieSide`s WITH DIFFERENT GENERIC ARGUMENTS
        guard type(of: lhs.value) == type(of: rhs.value) else {
            return false
        }
        return lhs.value == rhs.value
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

extension DieSide: CustomStringConvertible where OutputType: CustomStringConvertible {
    public var description: String {
        return "A DieSide containing {\(value.description)}"
    }
}

extension DieSide: CustomDebugStringConvertible where OutputType: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "DieSide(\(value.debugDescription))"
    }
}
