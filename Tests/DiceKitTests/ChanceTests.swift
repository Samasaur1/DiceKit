@testable import DiceKit
import XCTest

final class ChanceTests: XCTestCase {
    func testInitialization() {
        XCTAssertNil(try? Chance.oneOut(of: 0))
        XCTAssertNotNil(try? Chance.oneOut(of: 1))
        XCTAssertNil(try? Chance.oneOut(of: -1))
        XCTAssertNotNil(try? Chance.oneOut(of: 5))
        XCTAssertNil(try? Chance.oneOut(of: -5))

        XCTAssertNil(try? Chance(oneOutOf: 0))
        XCTAssertNotNil(try? Chance(oneOutOf: 1))
        XCTAssertNil(try? Chance(oneOutOf: -1))
        XCTAssertNotNil(try? Chance(oneOutOf: 5))
        XCTAssertNil(try? Chance(oneOutOf: -5))

        XCTAssertNotNil(try? Chance(1, outOf: 1))
        XCTAssertNil(try? Chance(2, outOf: 1))
        XCTAssertNotNil(try? Chance(1, outOf: 2))
        XCTAssertNotNil(try? Chance(0, outOf: 1))
        XCTAssertNil(try? Chance(1, outOf: 0))
        XCTAssertNotNil(try? Chance(2, outOf: 3))
        XCTAssertNil(try? Chance(3, outOf: 2))
        XCTAssertNil(try? Chance(-1, outOf: 2))
        XCTAssertNil(try? Chance(-2, outOf: 1))
        XCTAssertNotNil(try? Chance(6, outOf: 6))
        XCTAssertNotNil(try? Chance(0, outOf: 6))
        XCTAssertNil(try? Chance(6, outOf: 0))

        XCTAssertNotNil(try? Chance(approximating: 0))
        XCTAssertNotNil(try? Chance(approximating: 1))
        XCTAssertNil(try? Chance(approximating: 2))
        XCTAssertNil(try? Chance(approximating: -1))
        XCTAssertNil(try? Chance(approximating: Double.pi / 3))
        XCTAssertNotNil(try? Chance(approximating: Double.pi / 4))
        XCTAssertNotNil(try? Chance(approximating: 0.5))
        XCTAssertNil(try? Chance(approximating: 1.5))
        XCTAssertNotNil(try? Chance(approximating: 0.000_000_234))
    }

    func testDoubleApproximation() {
        let c: Chance = 0.25
        XCTAssertTrue(c.fraction == (1, 4))
        let c2 = try! Chance(approximating: 1.0 / 3.0)
        XCTAssertTrue(c2.fraction == (1, 3))
//        XCTAssertEqual(c.fraction, (1, 4)) This doesn't work for some stupid reason
    }

    func testProperties() {
        let c = try! Chance(1, outOf: 4)
        XCTAssertTrue((1, 4) == c.fraction)
        XCTAssertEqual(c.n, 1)
        XCTAssertEqual(c.d, 4)
        XCTAssertTrue((c.n, c.d) == c.fraction)
    }

    func testEquatable() {
        let c = try! Chance(oneOutOf: 10)
        let c2 = try! Chance(1, outOf: 10)
        let c3 = try! Chance(approximating: 0.1)
        let c4: Chance = 0.1
        let c5 = try! Chance(2, outOf: 20)

        XCTAssertAllEqual(c, c2, c3, c4, c5)
    }

    func testAddition() {
        let oneSixth = try! Chance(1, outOf: 6)
        let oneThird = try! Chance(1, outOf: 3)
        let oneHalf = try! Chance(1, outOf: 2)

        XCTAssertEqual(oneSixth + oneThird, oneHalf)
    }
    
    func testSubtraction() {
        let oneSixth = try! Chance(1, outOf: 6)
        let oneThird = try! Chance(1, outOf: 3)
        let oneHalf = try! Chance(1, outOf: 2)
        
        XCTAssertEqual(oneHalf - oneSixth, oneThird)
    }
}
