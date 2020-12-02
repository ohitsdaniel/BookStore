// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FruityBooks",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "FruityBooks",
            targets: ["FruityBooks"]
        )
    ],
    dependencies: [
        .package(path: "../BooksCore")
    ],
    targets: [
        .target(
            name: "FruityBooks",
            dependencies: [
                .product(name: "BooksCore", package: "BooksCore")
            ]
        ),
        .testTarget(
            name: "FruityBooksTests",
            dependencies: ["FruityBooks"]
        )
    ]
)
