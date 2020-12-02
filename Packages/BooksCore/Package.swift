// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BooksCore",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "BooksCore",
            targets: ["BooksCore"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "BooksCore",
            dependencies: []
        ),
        .testTarget(
            name: "BooksCoreTests",
            dependencies: ["BooksCore"]
        )
    ]
)
