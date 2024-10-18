// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DGExpandableText",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "DGExpandableText",
            targets: ["DGExpandableText"]),
    ],
    dependencies: [
        .package(url: "https://github.com/donggyushin/DGLineHeight", from: "1.0.4")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DGExpandableText",
            dependencies: [
                .product(name: "DGLineHeight", package: "DGLineHeight")
            ]
        ),
        .testTarget(
            name: "DGExpandableTextTests",
            dependencies: ["DGExpandableText"]
        ),
    ]
)
