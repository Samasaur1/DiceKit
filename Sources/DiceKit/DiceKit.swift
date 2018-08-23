import Foundation

internal class Random {
    static func random(min: Int = 0, max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max - min))) + min
    }
}

public protocol Rollable {
    func roll() -> Roll
}
