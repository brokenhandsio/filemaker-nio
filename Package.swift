// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "filemaker-nio",
    products: [
        .library(
            name: "FileMakerNIO",
            targets: ["FileMakerNIO"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "FileMakerNIO",
            dependencies: [
                .product(name: "AsyncHTTPClient", package: "async-http-client")
            ]),
        .testTarget(
            name: "FileMakerNIOTests",
            dependencies: ["FileMakerNIO"]),
    ]
)
