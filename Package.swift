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
        .package(url: "https://github.com/bitflying/SwiftKeccak.git", .branchItem("master"))
    ],
    targets: [
        .target(
            name: "Ethereum",
            dependencies: [.product(name: "secp256k1", package: "secp256k1.swift"), "SwiftKeccak"]
        ),
        .testTarget(
            name: "EthereumTests",
            dependencies: ["Ethereum"]
        )
    ]
)
