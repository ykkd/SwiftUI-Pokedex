// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Common",
    platforms: [
        .macOS(.v14),
    ],
    dependencies: [
        .package(url: "https://github.com/yonaskolb/Mint.git", exact: .init(stringLiteral: "0.17.5")),
    ],
    targets: [
        .target(name: "Common", path: ""),
    ]
)
