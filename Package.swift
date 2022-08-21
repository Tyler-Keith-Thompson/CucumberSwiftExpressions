// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CucumberSwiftExpressions",
    products: [
        .library(
            name: "CucumberSwiftExpressions",
            targets: ["CucumberSwiftExpressions"]),
    ],
    dependencies: [ ],
    targets: [
        .target(
            name: "CucumberSwiftExpressions",
            dependencies: []),
        .testTarget(
            name: "CucumberSwiftExpressionsTests",
            dependencies: ["CucumberSwiftExpressions"]),
    ]
)
