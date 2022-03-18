// swift-tools-version: 5.4

import PackageDescription

let package = Package(
    name: "Ethereum",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Ethereum",
            targets: ["Ethereum"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Ethereum"
        )
    ]
)
