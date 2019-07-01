@testable import DiceKit
import XCTest

final class CustomDieTests: XCTestCase {
    func testInitialization() {
        let d = try? CustomDie<Int>(sides: [])
        XCTAssertNil(d, "A CustomDie passed an empty array was non-nil")
        let d2 = try? CustomDie<Int>(sides: [DieSide(1)])
        XCTAssertNotNil(d2, "A one-sided CustomDie was nil")
        let d3 = CustomDie<Int>(copyOf: d2!)
        XCTAssertEqual(d2, d3, "A copied CustomDie was different")
        let d4 = try? CustomDie(sides: [DieSide<Int>(1), DieSide<Int>(2), DieSide<Int>(3)])
        XCTAssertNotNil(d4)
        let d5 = try? CustomDie(sides: [DieSide("Hello"), DieSide("World")])
        XCTAssertNotNil(d5)
        let d6 = try? CustomDie<AnyHashable>(sides: [DieSide("Hello"), DieSide(1)])
        XCTAssertNotNil(d6)
        let d7 = d6!.copy()
        XCTAssertEqual(d6!, d7)
    }

    func testRolling() {
        let d = try! CustomDie(sides: [DieSide("Hello")])
        XCTAssertEqual(DieSide("Hello"), d.roll(), "A single-sided CustomDie didn't return the right thing")
        //FIXME: The above line should be in tests for DieSide
        XCTAssertEqual("Hello", d.roll().value, "A single-sided CustomDie didn't return the right thing")

        let d2 = try! CustomDie(sides: [DieSide("Hello"), DieSide("World")])
        var gotHello = false
        var gotWorld = false
        for _ in 0..<1_000 {
            let r = d2.roll().value
            if r == "Hello" {
                gotHello = true
            }
            if r == "World" {
                gotWorld = true
            }
        }
        XCTAssertTrue(gotHello && gotWorld, "One side was never rolled!\nGot \"Hello\":\t\(gotHello)\nGot \"World\":\t\(gotWorld)")
    }

    func testEquatable() {
        let d1 = try! CustomDie(sides: [DieSide("Hello"), DieSide("World")])
        let d2 = try! CustomDie(sides: [DieSide("Hello"), DieSide("World")])
        XCTAssertEqual(d1, d2)

        let d3 = try! CustomDie(sides: [DieSide("One"), DieSide("Two")])
        let d4 = try! CustomDie(sides: [DieSide("Two"), DieSide("One")])
        XCTAssertEqual(d3, d4)

        XCTAssertNotEqual(d1, d3)
        XCTAssertNotEqual(d1, d4)
        XCTAssertNotEqual(d2, d3)
        XCTAssertNotEqual(d2, d4)
    }

    func testHashable() {
        let d1 = try! CustomDie(sides: [DieSide("Hello"), DieSide("World")])
        let d2 = try! CustomDie(sides: [DieSide("Hello"), DieSide("World")])
        let d3 = try! CustomDie(DieSide("Hello"), DieSide("World"))
        let d4 = try! CustomDie(sides: [DieSide(4), DieSide(9)])
        let hv1 = d1.hashValue //hashValue is now a computed property, don't worry
        let hv2 = d2.hashValue
        let hv3 = d3.hashValue
        let hv4 = d4.hashValue
        XCTAssertEqual(hv1, hv2)
        XCTAssertEqual(hv1, hv3)
        XCTAssertNotEqual(hv1, hv4)
        XCTAssertEqual(hv2, hv3)
        XCTAssertNotEqual(hv2, hv4)
        XCTAssertNotEqual(hv3, hv4)
    }

    func testSidesProperty() {
        let d1 = try! CustomDie(sides: [DieSide("Hello"), DieSide("World")])
        XCTAssertEqual(d1.sides.values.sorted { $0.value < $1.value }, [DieSide("Hello"), DieSide("World")].sorted { $0.value < $1.value })
    }

    func testReplacing() {
        let d1 = try! CustomDie(sides: [DieSide("Hello"), DieSide("World")])
        let d2 = d1.replacing(DieSide("World"), with: DieSide("World!"))
        let d3 = try! CustomDie(sides: [DieSide("Hello"), DieSide("World!")])
        XCTAssertEqual(d2, d3)
        XCTAssertNotEqual(d1, d2)
//        XCTAssertEqual(d2.sides, d3.sides) //The order of this may be different, so it is not necessarily equal
    }

    func testChance() {
        let d = try! CustomDie(DieSide(2), DieSide(4), DieSide(6), DieSide(8), DieSide(10), DieSide(10))

        let chance = d.chance(of: DieSide(1))
        let chance2 = d.chance(of: DieSide(2))
        let chance3 = d.chance(of: DieSide(10))

        XCTAssertEqual(chance, Chance.zero)
        XCTAssertEqual(chance2, try! Chance(oneOutOf: 6))
        XCTAssertEqual(chance3, try! Chance(2, outOf: 6))
    }
}
