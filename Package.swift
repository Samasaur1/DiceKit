// swift-tools-version:4.2
// Managed by ice

import PackageDescription

let package = Package(
    name: "DiceKit",
    products: [
        .library(name: "DiceKit", targets: ["DiceKit"]),
    ],
    dependencies: [
//      .package(url: "https://github.com/danger/swift.git", from: "1.0.0"), //dev
        .package(url: "https://github.com/attaswift/BigInt.git", from: "4.0.0")
    ],
    targets: [
        .target(name: "DiceKit", dependencies: ["BigInt"]),
        .testTarget(name: "DiceKitTests", dependencies: ["DiceKit", "BigInt"]), //nodev
//      .testTarget(name: "DiceKitTests", dependencies: ["DiceKit", "BigInt", "Danger"]), //dev
    ],
    swiftLanguageVersions: [.v4_2, .version("5")]
)
