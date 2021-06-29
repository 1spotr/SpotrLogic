// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SpotrLogic",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SpotrLogic",
            targets: ["SpotrLogic"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // 🔥 Firebase
         .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "8.2.0"),

        // 📃 Log
        .package(url: "https://github.com/apple/swift-log.git", from: "1.4.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SpotrLogic",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
//                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
            ]),
        .testTarget(
            name: "SpotrLogicTests",
            dependencies: ["SpotrLogic"]),
    ]
)
