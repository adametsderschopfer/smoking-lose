// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SmokeQuitCore",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(
            name: "SmokeQuitCore",
            targets: ["SmokeQuitCore"]
        ),
    ],
    targets: [
        .target(
            name: "SmokeQuitCore",
            path: "smoking-lose/Core"
        ),
        .testTarget(
            name: "SmokeQuitCoreTests",
            dependencies: ["SmokeQuitCore"]
        ),
    ]
)
