@testable import DiceKit
import XCTest

final class NegationTests: XCTestCase {
    func testInitialization() {
        let d = Die.d6
        XCTAssertTrue(-d == Negation.of(d))
    }

    func testDoubleNegation() {
        let d = Die.d6
        let n = -d
        let n2 = -n
        XCTAssertTrue(n2 == d)
    }

    func testRolling() {
        let n = -Die.d6
        var rolled = [true, false, false, false, false, false, false]
        while rolled.contains(false) {
            let r = n.roll()
            XCTAssertGreaterThanOrEqual(r, -6)
            XCTAssertLessThanOrEqual(r, -1) //If the die is changed away from a d6, change this
            rolled[-r] = true
        }

        let n2 = -Dice(try! Die.init(sides: 5), withModifier: -2)
        rolled = [false, false, false, false, false]
        while rolled.contains(false) {
            let r = n2.roll()
            XCTAssertGreaterThanOrEqual(r, -3)
            XCTAssertLessThanOrEqual(r, 1)
            rolled[r + 3] = true
        }
    }

    func testMinimumResult() {
        XCTAssertEqual((-Die.d6).minimumResult, -6)
        XCTAssertEqual((-Dice(try! Die.init(sides: 5), withModifier: -2)).minimumResult, -3)
        XCTAssertEqual((-Die.d6).minimumResult, -Die.d6.maximumResult)
    }

    func testMaximumResult() {
        XCTAssertEqual((-Die.d6).maximumResult, -1)
        XCTAssertEqual((-Dice(try! Die.init(sides: 5), withModifier: -2)).maximumResult, 1)
    }

    func testAverageResult() {
        XCTAssertEqual((-Die.d6).averageResult, -Die.d6.averageResult)
        XCTAssertEqual((-Dice(try! Die.init(sides: 5), withModifier: -2)).averageResult, -Dice(try! Die.init(sides: 5), withModifier: -2).averageResult)
    }

    func testCanReach() {
        let n = -Die.d6
        XCTAssertFalse(n.canReach(0, .exactly))
        XCTAssertFalse(n.canReach(0, .orHigher))
        XCTAssertTrue(n.canReach(0, .orLower))

        XCTAssertTrue(n.canReach(-1, .exactly))
        XCTAssertTrue(n.canReach(-1, .orHigher))
        XCTAssertTrue(n.canReach(-1, .orLower))
    }

    func testProbabilities() {
        let n = -Die.d6

        XCTAssertEqual(n.chance(of: (-3)...), try! .init(oneOutOf: 2))
        XCTAssertEqual(n.chance(of: (-2)...), try! .init(oneOutOf: 3))
    }
}
