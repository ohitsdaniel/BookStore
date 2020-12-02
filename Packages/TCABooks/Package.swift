// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TCABooks",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "TCABooks",
            targets: ["TCABooks"]
        ),
    ],
    dependencies: [
         .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: "0.9.0"
         ),
        .package(path: "../BooksCore")
    ],
    targets: [
        .target(
            name: "TCABooks",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
                .product(
                    name: "BooksCore",
                    package: "BooksCore"
                )
            ]
        ),
        .testTarget(
            name: "TCABooksTests",
            dependencies: ["TCABooks"]
        )
    ]
)
