internal extension Array where Element == Roll {
    var sum: Roll {
        var total = 0
        for r in self {
            total += r
        }
        return total
    }
}

internal extension String {
    var isNumeric: Bool {
        guard !self.isEmpty else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
}

internal extension Array where Element == Double {
    var sum: Double {
        var total = 0.0
        for el in self {
            total += el
        }
        return total
    }
}
#if !swift(>=5.1) //Can't use `#if swift(<5.1)` for earlier than Swift 5
internal extension Sequence {
    func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
        var count = 0
        for e in self {
            if try predicate(e) {
                count += 1
            }
        }
        return count
    }
}
#else
#error("Do we still need this?")
#endif

import Foundation
internal struct FileHandleOutputStream: TextOutputStream {
    private let fileHandle: FileHandle
    let encoding: String.Encoding

    init(_ fileHandle: FileHandle, encoding: String.Encoding = .utf8) {
        self.fileHandle = fileHandle
        self.encoding = encoding
    }

    mutating func write(_ string: String) {
        if let data = string.data(using: encoding) {
            fileHandle.write(data)
        }
    }
}
internal var STDERR = FileHandleOutputStream(.standardError)
internal var STDOUT = FileHandleOutputStream(.standardOutput)

private enum LazyValue<Input, Value> {
    case notYetComputed((Input) -> Value)
    case computed(Value)
}
internal class LazyBox<Input, Result> {
    init(computation: @escaping (Input) -> Result) {
        _value = .notYetComputed(computation)
    }

    private var _value: LazyValue<Input, Result>

    /// All reads and writes of `_value` must
    /// happen on this queue.
    private let queue = DispatchQueue(label: "LazyBox._value")

    func value(input: Input) -> Result {
        var returnValue: Result? = nil
        queue.sync {
            switch self._value {
            case .notYetComputed(let computation):
                let result = computation(input)
                self._value = .computed(result)
                returnValue = result
            case .computed(let result):
                returnValue = result
            }
        }
        assert(returnValue != nil)
        return returnValue!
    }
}
