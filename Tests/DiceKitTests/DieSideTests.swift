import XCTest
@testable import DiceKit

final class DieSideTests: XCTestCase {
    func testInitialization() {
        let _ = DieSide<Bool?>(nil)
        let _ = DieSide(1)
        let _ = DieSide("Hello")
        let _ = DieSide<String>("x")
        let _ = DieSide<AnyHashable>(5.0)
    }
    
    func testValueProperty() {
        let ds = DieSide<Int>(10)
        XCTAssertEqual(ds.value, 10)
        let ds2 = DieSide<AnyHashable>(5.0)
        XCTAssertEqual(ds2.value, 5.0)
        let ds3 = DieSide("Hello")
        XCTAssertEqual(ds3.value, "Hello")
    }
    
    func testEquatable() {
        let ds = DieSide<Int>(5)
        let ds2 = DieSide<AnyHashable>(5)
//        XCTAssertNotEqual(ds, ds2) //This throws a compiler error, because the equals function only takes DieSides of the same type, and if I try to declare it so that it takes different types, I get "ambiguous reference to function ==" or something
        let ds3 = DieSide(5)
        let ds4 = DieSide(4)
        XCTAssertEqual(ds, ds3)
        XCTAssertNotEqual(ds, ds4)
        XCTAssertNotEqual(ds3, ds4)
        let ds5 = DieSide<AnyHashable>("Hello")
        XCTAssertNotEqual(ds2, ds5)
        let ds6 = DieSide<AnyHashable>(5)
        XCTAssertEqual(ds2, ds6)
    }
    
    func testHashable() {
        let ds = DieSide<Int>(5).hashValue
        let ds2 = DieSide<AnyHashable>(5).hashValue
        let ds3 = DieSide(5).hashValue
        let ds4 = DieSide(4).hashValue
        XCTAssertEqual(ds, ds3)
        XCTAssertNotEqual(ds, ds4)
        
        
        XCTAssertEqual(ds, ds2)
        // Okay, when I wrote this the implementation for the hashing of a DieSide was this:
        //
        //    public func hash(into hasher: inout Hasher) {
        //        hasher.combine(value)
        //    }
        //
        // So **this is a hash collision, not something that needs to be true**.*However*, if this ever fails, you've changed the hashing function to use the type. That's good; I would do that if I could. It just means you should (probably) update the test to reflect that.
    }
}
