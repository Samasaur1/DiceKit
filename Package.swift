// swift-tools-version:4.0
// Managed by ice

import PackageDescription

let package = Package(
    name: "DiceKit",
    products: [
        .library(name: "DiceKit", targets: ["DiceKit"]),
    ],
    dependencies: [
        .package(url: "git@github.com:Samasaur1/ProtocolKit.git", from: "1.0.0"),
    ],
    targets: [
        .target(name: "DiceKit", dependencies: ["ProtocolKit"]),
        .testTarget(name: "DiceKitTests", dependencies: ["DiceKit"]),
    ]
)
