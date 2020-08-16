// swift-tools-version:5.0
// Managed by ice

import PackageDescription

let package = Package(
    name: "DiceKit",
    platforms: [
        .iOS(.v8), .macOS(.v10_10), .watchOS(.v2), .tvOS(.v9)// .linux (not a SupportedPlatform, just a Platform
    ],
    products: [
        .library(name: "DiceKit", targets: ["DiceKit"]),
    ],
    dependencies: [
//      .package(url: "https://github.com/danger/swift.git", from: "1.0.0"), //dev
        .package(url: "https://github.com/attaswift/BigInt.git", from: "5.0.0")
    ],
    targets: [
        .target(name: "DiceKit", dependencies: ["BigInt"]),
        .testTarget(name: "DiceKitTests", dependencies: ["DiceKit", "BigInt"]), //nodev
//      .testTarget(name: "DiceKitTests", dependencies: ["DiceKit", "BigInt", "Danger"]), //dev
    ],
    swiftLanguageVersions: [.v4_2, .v5]
)
