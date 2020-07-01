// swift-tools-version:4.2
// Managed by ice

import PackageDescription

let package = Package(
    name: "DiceKit",
    products: [
        .library(name: "DiceKit", targets: ["DiceKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/danger/swift.git", from: "1.0.0"), //dev
    ],
    targets: [
        .target(name: "DiceKit", dependencies: []),
//        .testTarget(name: "DiceKitTests", dependencies: ["DiceKit"]), //nodev
        .testTarget(name: "DiceKitTests", dependencies: ["DiceKit", "Danger"]), //dev
    ]
)
