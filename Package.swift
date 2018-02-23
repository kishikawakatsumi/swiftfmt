// swift-tools-version:4.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swiftfmt",
    dependencies: [
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "swiftfmt",
            dependencies: ["swiftfmt-core", "Utility"]),
        .target(
            name: "swiftfmt-core",
            dependencies: ["Utility"]),
        .testTarget(
            name: "tests",
            dependencies: ["swiftfmt-core"]),
    ]
)
