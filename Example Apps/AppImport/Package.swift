// swift-tools-version: 5.4

import PackageDescription

let package = Package(
    name: "AppImport",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "AppImport", targets: ["AppImport"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ivanvorobei/SparrowKit", .upToNextMajor(from: "3.5.0"))
    ],
    targets: [
        .target(
            name: "AppImport",
            dependencies: [
                .product(name: "SparrowKit", package: "SparrowKit")
            ]
        )
    ]
)
