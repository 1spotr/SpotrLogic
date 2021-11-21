// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SpotrLogic",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SpotrLogic",
            targets: ["SpotrLogic"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // 🔥 Firebase
        .package(name: "Firebase",
                 url: "https://github.com/firebase/firebase-ios-sdk.git",
                 .exact("8.2.0")),

        // 📃 Log
        .package(url: "https://github.com/apple/swift-log.git", from: "1.4.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        .target(
            name: "SpotrLogic",
            dependencies: [
                .product(name: "FirebaseAuth", package: "Firebase"),
                .product(name: "FirebaseFirestore", package: "Firebase"),
                .product(name: "FirebaseFirestoreSwift-Beta", package: "Firebase"),
                .product(name: "Logging", package: "swift-log"),
            ]),
        .testTarget(
            name: "SpotrLogicTests",
            dependencies: ["SpotrLogic"],
            resources: [
                .process("./Resources/GoogleService-Info.plist"),
                .process("./Resources/spot.json"),
                .process("./Resources/tag.json"),
                .process("./Resources/area_singapore.json"),
                .process("./Resources/Areas/area.json")
            ]),
    ]
)
