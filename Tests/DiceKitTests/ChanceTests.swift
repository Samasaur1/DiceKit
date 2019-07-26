@testable import DiceKit
import XCTest

final class ChanceTests: XCTestCase {
    func testInitialization() {
        let c = try? Chance.oneOut(of: 0)
        let c2 = try? Chance.oneOut(of: 1)
        let c3 = try? Chance.oneOut(of: -1)
        let c4 = try? Chance.oneOut(of: 5)
        let c5 = try? Chance.oneOut(of: -5)
        XCTAssertNil(c)
        XCTAssertNotNil(c2)
        XCTAssertNil(c3)
        XCTAssertNotNil(c4)
        XCTAssertNil(c5)

        let c6 = try? Chance(oneOutOf: 0)
        let c7 = try? Chance(oneOutOf: 1)
        let c8 = try? Chance(oneOutOf: -1)
        let c9 = try? Chance(oneOutOf: 5)
        let c10 = try? Chance(oneOutOf: -5)
        XCTAssertNil(c6)
        XCTAssertNotNil(c7)
        XCTAssertNil(c8)
        XCTAssertNotNil(c9)
        XCTAssertNil(c10)

        let c11 = try? Chance(1, outOf: 1)
        let c12 = try? Chance(2, outOf: 1)
        let c13 = try? Chance(1, outOf: 2)
        let c14 = try? Chance(0, outOf: 1)
        let c15 = try? Chance(1, outOf: 0)
        let c16 = try? Chance(2, outOf: 3)
        let c17 = try? Chance(3, outOf: 2)
        let c18 = try? Chance(-1, outOf: 2)
        let c19 = try? Chance(-2, outOf: 1)
        let c20 = try? Chance(6, outOf: 6)
        let c21 = try? Chance(0, outOf: 6)
        let c22 = try? Chance(6, outOf: 0)
        XCTAssertNotNil(c11)
        XCTAssertNil(c12)
        XCTAssertNotNil(c13)
        XCTAssertNotNil(c14)
        XCTAssertNil(c15)
        XCTAssertNotNil(c16)
        XCTAssertNil(c17)
        XCTAssertNil(c18)
        XCTAssertNil(c19)
        XCTAssertNotNil(c20)
        XCTAssertNotNil(c21)
        XCTAssertNil(c22)

        let c23 = try? Chance(approximating: 0)
        let c24 = try? Chance(approximating: 1)
        let c25 = try? Chance(approximating: 2)
        let c26 = try? Chance(approximating: -1)
        let c27 = try? Chance(approximating: Double.pi / 3)
        let c27prime = try? Chance(approximating: Double.pi / 4)
        let c28 = try? Chance(approximating: 0.5)
        let c29 = try? Chance(approximating: 1.5)
        let c30 = try? Chance(approximating: 0.000_000_234)
        XCTAssertNotNil(c23)
        XCTAssertNotNil(c24)
        XCTAssertNil(c25)
        XCTAssertNil(c26)
        XCTAssertNil(c27)
        XCTAssertNotNil(c27prime)
        XCTAssertNotNil(c28)
        XCTAssertNil(c29)
        XCTAssertNotNil(c30)
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

        XCTAssertEqual(c, c2)
        XCTAssertEqual(c, c3)
        XCTAssertEqual(c, c4)
        XCTAssertEqual(c, c5)

        XCTAssertEqual(c2, c)
        XCTAssertEqual(c2, c3)
        XCTAssertEqual(c2, c4)
        XCTAssertEqual(c2, c5)

        XCTAssertEqual(c3, c)
        XCTAssertEqual(c3, c2)
        XCTAssertEqual(c3, c4)
        XCTAssertEqual(c3, c5)

        XCTAssertEqual(c4, c)
        XCTAssertEqual(c4, c2)
        XCTAssertEqual(c4, c3)
        XCTAssertEqual(c4, c5)

        XCTAssertEqual(c5, c)
        XCTAssertEqual(c5, c2)
        XCTAssertEqual(c5, c3)
        XCTAssertEqual(c5, c4)
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
