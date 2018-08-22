#if !os(Linux)
import Foundation
#endif
internal class Random {
    #if os(Linux)
    static var initialized = false
    #endif
    static func random(min: Int = 0, max: Int) -> Int {
        #if os(Linux)
        if !initialized {
            srandom(UInt32(time(nil)))
            initialized = true
        }
        return (random() % (max - min)) + min
        #else
        return Int(arc4random_uniform(UInt32(max - min))) + min
        #endif
    }
}

public protocol Rollable {
    func roll() -> Roll
}
