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
								.package(
												name: "Firebase",
												url: "https://github.com/akaffenberger/firebase-ios-sdk-xcframeworks.git",
												.exact("8.10.0")
								),

        // 📃 Log
        .package(url: "https://github.com/apple/swift-log.git", from: "1.4.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        .target(
            name: "SpotrLogic",
            dependencies: [
																"FirebaseFirestoreSwift",
                .product(name: "FirebaseAuth", package: "Firebase"),
                .product(name: "FirebaseFirestore", package: "Firebase"),
                .product(name: "Logging", package: "swift-log"),
            ],
												swiftSettings: [
																.unsafeFlags([
//																				"-Xfrontend", "-enable-experimental-concurrency",
																				"-Xfrontend", "-disable-availability-checking",
																])
												]
								),

												.binaryTarget(name: "FirebaseFirestoreSwift", path: "Firebase/FirebaseFirestoreSwift/FirebaseFirestoreSwift.xcframework"),

        .testTarget(
            name: "SpotrLogicTests",
            dependencies: [
																"SpotrLogic",
//																"FirebaseFirestoreSwift",
												],
            resources: [
                .process("./Resources/")
            ]),
    ]
)
