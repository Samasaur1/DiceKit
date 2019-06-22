// swift-tools-version:4.1
// Managed by ice

import PackageDescription

let package = Package(
    name: "DiceKit",
    products: [
        .library(name: "DiceKit", targets: ["DiceKit"]),
    ],
    targets: [
        .target(name: "DiceKit", dependencies: []),
        .testTarget(name: "DiceKitTests", dependencies: ["DiceKit"]),
    ]
)
