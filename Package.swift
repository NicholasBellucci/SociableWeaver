// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SociableWeaver",
    products: [
        .library(
            name: "SociableWeaver",
            targets: ["SociableWeaver"]),
    ],
    targets: [
        .target(
            name: "SociableWeaver",
            dependencies: []),
        .testTarget(
            name: "SociableWeaverTests",
            dependencies: ["SociableWeaver"]),
    ]
)
