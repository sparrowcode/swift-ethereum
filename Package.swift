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
    dependencies: [
        .package(url: "https://github.com/GigaBitcoin/secp256k1.swift.git", .branchItem("main")),
        .package(url: "https://github.com/bitflying/SwiftKeccak.git", .branchItem("master")),
        .package(url: "https://github.com/attaswift/BigInt.git", from: "5.3.0")
    ],
    targets: [
        .target(
            name: "Ethereum",
            dependencies: [.product(name: "secp256k1", package: "secp256k1.swift"), "SwiftKeccak", "BigInt"]
        ),
        .testTarget(
            name: "EthereumTests",
            dependencies: ["Ethereum"]
        )
    ]
)
