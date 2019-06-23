import XCTest
@testable import DiceKit

final class CustomDieTests: XCTestCase {
    func testInitialization() {
        let d = try? CustomDie<Int>.init(sides: [])
        XCTAssertNil(d, "A CustomDie passed an empty array was non-nil")
        let d2 = try? CustomDie<Int>.init(sides: [DieSide.init(1)])
        XCTAssertNotNil(d2, "A one-sided CustomDie was nil")
        let d3 = CustomDie<Int>.init(copyOf: d2!)
        XCTAssertEqual(d2, d3, "A copied CustomDie was different")
        let d4 = try? CustomDie.init(sides: [DieSide<Int>.init(1), DieSide<Int>.init(2), DieSide<Int>.init(3)])
        XCTAssertNotNil(d4)
        let d5 = try? CustomDie.init(sides: [DieSide.init("Hello"), DieSide.init("World")])
        XCTAssertNotNil(d5)
        let d6 = try? CustomDie<AnyHashable>.init(sides: [DieSide.init("Hello"), DieSide.init(1)])
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
        for _ in 0..<1000 {
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
        var h1 = Hasher()
        h1.combine(d1)
        let hv1 = h1.finalize()
        var h2 = Hasher()
        h2.combine(d2)
        let hv2 = h2.finalize()
        var h3 = Hasher()
        h3.combine(d3)
        let hv3 = h3.finalize()
        var h4 = Hasher()
        h4.combine(d4)
        let hv4 = h4.finalize()
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
}
