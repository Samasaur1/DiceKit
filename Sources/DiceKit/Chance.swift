/// A struct that represents the chance or probability of something happening.
///
/// Chances are stored as fractions, and the constructors that take decimal values use some algorithm off of StackOverflow to convert them to fractions.
///
/// - Since: 0.16.0
/// - Author: Samasaur
public struct Chance {
    /// The numerator of the fraction
    public let n: Int
    /// The denominator of the fraction
    public let d: Int
    /// The decimal representation of the fraction.
    public var value: Double {
        return Double(n) / Double(d)
    }
    /// The fraction as a tuple (numerator, denominator).
    public var fraction: (Int, Int) {
        return (n, d)
    }

    /// Creates a new `Chance` object of the fraction form 1/d.
    ///
    /// - Parameter d: The denominator of the fraction.
    /// - Returns: A new fraction with the given denominator and a numerator of 1.
    /// - Throws: `Error.divisionByZero`, `Error.negativeArgument`, or `Error.chanceOverOne`
    public static func oneOut(of d: Int) throws -> Chance {
        return try self.init(1, outOf: d)
    }

    /// Creates a new `Chance` object of the fraction form n/d.
    ///
    /// - Parameters:
    ///   - n: The numerator of the fraction.
    ///   - d: The denominator of the fraction.
    /// - Throws: `Error.divisionByZero`, `Error.negativeArgument`, or `Error.chanceOverOne`
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
        let simplify: (Int, Int) -> (n: Int, d: Int) = { top, bottom in
            //swiftline:disable all
            var x = top
            var y = bottom
            while y != 0 {
                let buffer = y
                y = x % y
                x = buffer
            }
            let hcfVal = x
            let newTopVal = top / hcfVal
            let newBottomVal = bottom / hcfVal
            //swiftlint:enable all
            return(newTopVal, newBottomVal)
        }
        let simple = simplify(n, d)
        self.n = simple.n
        self.d = simple.d
    }

    /// Creates a new `Chance` object of the fraction form 1/d.
    ///
    /// - Parameter d: The denominator of the fraction.
    /// - Throws: `Error.divisionByZero`, `Error.negativeArgument`, or `Error.chanceOverOne`
    public init(oneOutOf d: Int) throws {
        try self.init(1, outOf: d)
    }

    /// Creates a new `Chance` object approximating the given decimal.
    ///
    /// This uses some algorithm off of StackOverflow.
    ///
    /// - Parameter x0: The decimal value to convert to a fraction.
    /// - Throws: `Error.negativeArgument` or `Error.chanceOverOne`
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
        //swiftlint:disable all
        let eps = 1.0E-6
        var x = x0
        var a = x.rounded(.down)
        var (h1, k1, h, k) = (1, 0, Int(a), 1)

        while x - a > eps * Double(k) * Double(k) {
            x = 1.0 / (x - a)
            a = x.rounded(.down)
            (h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
        }
        //swiftlint:enable all
        try self.init(h, outOf: k)
    }

    //swiftlint:disable force_try
    /// A `Chance` of zero.
    public static let zero = try! Chance(0, outOf: 1)
    /// A `Chance` of one.
    public static let one = try! Chance(1, outOf: 1)
    //swiftlint:enable force_try
}
extension Chance: Equatable {
    public static func == (lhs: Chance, rhs: Chance) -> Bool {
        return lhs.fraction == rhs.fraction
    }
}
extension Chance: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(n)
        hasher.combine(d)
    }
}
extension Chance: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = Double
    /// Creates a new `Chance` object approximating the given decimal. There is no error-checking!
    ///
    /// This function calls `init(approximating:)`, and will crash if that function throws an error.
    ///
    /// - Parameter value: The decimal value to convert to a fraction.
    public init(floatLiteral value: Chance.FloatLiteralType) {
        do {
            try self.init(approximating: value)
        } catch let err as Error {
            print(err, to: &STDERR)
            self = .zero
        } catch {
            print("""

                <ERROR>

                Initializing a Chance using init(floatLiteral:) threw a non-DiceKit error, which shouldn't ever happen.
                Please create a new issue here: https://github.com/Samasaur1/DiceKit/issues/new
                and provide the following information:

                floatLiteral:   \(value)
                err:            \(error)

                </ERROR>

                """, to: &STDERR)
            fatalError("Non-DiceKit error came back from Chance.init(approximating:)\n\nSee above\n")
        }
    }
}
public extension Chance {
    /// The greatest common divisor/factor of two integers.
    ///
    /// - Parameters:
    ///   - a: The first integer.
    ///   - b: The second integer.
    /// - Returns: The greatest common divisor of the two integers.
    ///
    /// - Since: 0.17.0
    static func gcd(_ a: Int, _ b: Int) -> Int {
        var a = abs(a)
        var b = abs(b)
        if b > a {
            swap(&a, &b)
        }
        while b != 0 {
            (a, b) = (b, a % b)
        }
        return abs(a)
    }

    /// The least/lowest common multiple of two integers.
    ///
    /// - Parameters:
    ///   - a: The first integer.
    ///   - b: The second integer.
    /// - Returns: The lowest common multiple of the two integers.
    ///
    /// - Since: 0.17.0
    static func lcm(_ a: Int, _ b: Int) -> Int {
        let product = a.multipliedReportingOverflow(by: b)
        let _gcd = gcd(a, b)
        if product.overflow {
            let _lcm = gcd(a, _gcd)
            let _a = a / _lcm
            let __gcd = _gcd / _lcm
            let __lcm = gcd(b, __gcd)
            let _b = b / __lcm
            let ___gcd = __gcd / __lcm
            return abs(_a * _b) / ___gcd
        } else {
            return abs(product.partialValue) / _gcd
        }
////        return abs(a * b) / gcd(a, b)
//        return abs(a * (b / gcd(a, b)))
    }

    /// Adds two `Chance` instances together.
    ///
    /// - Parameters:
    ///   - lhs: The augend (first summand).
    ///   - rhs: The addend (second summand).
    /// - Returns: The sum of the two `Chance` instances.
    ///
    /// - Since: 0.17.0
    static func + (lhs: Chance, rhs: Chance) -> Chance {
        let lcm = Chance.lcm(lhs.d, rhs.d)
        let lnum = lhs.n * (lcm / lhs.d)
        let rnum = rhs.n * (lcm / rhs.d)
        return (try? .init(lnum + rnum, outOf: lcm)) ?? .one
    }

    /// Subtracts one `Chance` instance from another.
    ///
    /// - Parameters:
    ///   - lhs: The minuend (the value to be subtracted from).
    ///   - rhs: The subtrahend (the value to subtract).
    /// - Returns: The difference of the two values.
    ///
    /// - Since: 0.17.0
    static func - (lhs: Chance, rhs: Chance) -> Chance {
        let lcm = Chance.lcm(lhs.d, rhs.d)
        let lnum = lhs.n * lcm / lhs.d
        let rnum = rhs.n * lcm / rhs.d
        return (try? .init(lnum - rnum, outOf: lcm)) ?? .zero
    }

    /// Adds the two `Chance` instances and sets the left-hand instance to the sum.
    ///
    /// - Parameters:
    ///   - lhs: The summand that will be set to the sum.
    ///   - rhs: The summand that will not be set to the sum.
    ///
    /// - Since: 0.17.0
    static func += (lhs: inout Chance, rhs: Chance) {
        lhs = lhs + rhs //swiftlint:disable:this shorthand_operator
    }

    /// Multiplies two `Chance` instances together.
    /// - Parameters:
    ///   - lhs: The first factor to multiply.
    ///   - rhs: The second factor to multiply.
    /// - Returns: The product of the two factors.
    ///
    /// - Since: 0.24.0
    static func * (lhs: Chance, rhs: Chance) -> Chance {
        let _n = lhs.n.multipliedReportingOverflow(by: rhs.n)
        let _d = lhs.d.multipliedReportingOverflow(by: rhs.d)
        if _n.overflow || _d.overflow {
//            throw Error.overflow
            let _lhs = try! self.init(approximating: lhs.value)
            let _rhs = try! self.init(approximating: rhs.value)
            print("Multiplication overflow!", to: &STDERR)
            return (try? .init(_lhs.n * _rhs.n, outOf: _lhs.d * _rhs.d)) ?? .zero
        }
        return (try? .init(_n.partialValue, outOf: _d.partialValue)) ?? .zero
    }
}

extension Chance: Describable {
    public var description: String {
        return "\(n) out of \(d)"
    }
    public var debugDescription: String {
        return "\(n)/\(d)"
    }
}
