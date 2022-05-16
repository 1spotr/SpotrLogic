// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SpotrLogic",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    products: [
								.library(name: "SpotrVerse", targets: ["SpotrVerse"]),

        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SpotrLogic",
            targets: ["SpotrLogic"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        
        // 📃 Log
        .package(url: "https://github.com/apple/swift-log.git", from: "1.4.2"),
    ],
    targets: [
								.target(name: "SpotrVerse", dependencies: []),

								.testTarget(name: "SpotrVerseTests",
																				dependencies: ["SpotrVerse"]),

        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        .target(
            name: "SpotrLogic",
            dependencies: [
                "Firebase",
                "FirebaseAnalyticsTarget",
                "FirebaseAuthTarget",
                "FirebaseFirestoreTarget",
                "FirebaseFirestoreSwiftTarget",
                "FirebaseStorageTarget",
                .product(name: "Logging", package: "swift-log"),
            ],
            resources: [
                .process("Resources/gRPCCertificates-Cpp.bundle")
            ],
            linkerSettings: [
                .unsafeFlags(["-ObjC"])
            ]
        ),
        
        /// 🔥 Firebase
        /// Mapping
            .target(
                name: "Firebase",
                publicHeadersPath: "./",
                linkerSettings: [
                    .unsafeFlags(["-ObjC"])
                ]
            ),
        .target(
            name: "FirebaseAnalyticsTarget",
            dependencies: [
                "Firebase",
                "FirebaseAnalytics",
                "FirebaseCore",
                "FirebaseCoreDiagnostics",
                "FirebaseInstallations",
                "GoogleAppMeasurement",
                "GoogleAppMeasurementIdentitySupport",
                "GoogleDataTransport",
                "GoogleUtilities",
                "PromisesObjC",
                "nanopb"
            ],
            path: "Sources/FirebaseAnalytics",
            linkerSettings: [
                .unsafeFlags(["-ObjC"])
            ]
        ),
        .target(
            name: "FirebaseFirestoreTarget",
            dependencies: [
                "Firebase",
                "FirebaseAnalyticsTarget",
                "BoringSSL-GRPC",
                "FirebaseFirestore",
                "abseil",
                "gRPC-C++",
                "gRPC-Core",
                "leveldb-library"
            ],
            path: "Sources/FirebaseFirestore",
            resources: [
                .process("Resources/gRPCCertificates-Cpp.bundle")
            ],
            linkerSettings: [
                .unsafeFlags(["-ObjC"])
            ]
        ),
        .target(
            name: "FirebaseAuthTarget",
            dependencies: [
                "Firebase",
                "FirebaseAnalyticsTarget",
                "FirebaseAuth",
                "GTMSessionFetcher"
            ],
            path: "Sources/FirebaseAuth",
            linkerSettings: [
                .unsafeFlags(["-ObjC"])
            ]
        ),
        .target(
            name: "FirebaseFirestoreSwiftTarget",
            dependencies: [
                "Firebase",
                "FirebaseFirestoreSwift",
            ],
            path: "Sources/FirebaseFirestoreSwift",
            resources: [
                .copy("Resources/gRPCCertificates-Cpp.bundle")
            ],
            linkerSettings: [
                .unsafeFlags(["-ObjC"])
            ]
        ),
        
            .target(
                name: "FirebaseStorageTarget",
                dependencies: [
                    "Firebase",
                    "FirebaseStorage",
                    "GTMSessionFetcher",
                ],
                path: "Sources/FirebaseStorage",
                linkerSettings: [
                    .unsafeFlags(["-ObjC"])
                ]
            ),
        
        /// Binaary
        .binaryTarget(name: "FirebaseAnalytics", path: "Firebase/FirebaseAnalytics/FirebaseAnalytics.xcframework"),
        .binaryTarget(name: "FirebaseAppCheck", path: "Firebase/FirebaseAppCheck/FirebaseAppCheck.xcframework"),
        .binaryTarget(name: "FirebaseAppDistribution", path: "Firebase/FirebaseAppDistribution/FirebaseAppDistribution.xcframework"),
        .binaryTarget(name: "FirebaseAuth", path: "Firebase/FirebaseAuth/FirebaseAuth.xcframework"),
        .binaryTarget(name: "FirebaseFirestore", path: "Firebase/FirebaseFirestore/FirebaseFirestore.xcframework"),
        .binaryTarget(name: "FirebaseFirestoreSwift", path: "Firebase/FirebaseFirestoreSwift/FirebaseFirestoreSwift.xcframework"),
        .binaryTarget(name: "FirebaseStorage", path: "Firebase/FirebaseStorage/FirebaseStorage.xcframework"),
        
        
        /// 🥃 Dependencies
        /// Analytics
            .binaryTarget(name: "FirebaseCore", path: "Firebase/FirebaseAnalytics/FirebaseCore.xcframework"),
        .binaryTarget(name: "FirebaseCoreDiagnostics", path: "Firebase/FirebaseAnalytics/FirebaseCoreDiagnostics.xcframework"),
        .binaryTarget(name: "FirebaseInstallations", path: "Firebase/FirebaseAnalytics/FirebaseInstallations.xcframework"),
        .binaryTarget(name: "GoogleAppMeasurement", path: "Firebase/FirebaseAnalytics/GoogleAppMeasurement.xcframework"),
        .binaryTarget(name: "GoogleAppMeasurementIdentitySupport", path: "Firebase/FirebaseAnalytics/GoogleAppMeasurementIdentitySupport.xcframework"),
        .binaryTarget(name: "GoogleDataTransport", path: "Firebase/FirebaseAnalytics/GoogleDataTransport.xcframework"),
        .binaryTarget(name: "GoogleUtilities", path: "Firebase/FirebaseAnalytics/GoogleUtilities.xcframework"),
        .binaryTarget(name: "PromisesObjC", path: "Firebase/FirebaseAnalytics/PromisesObjC.xcframework"),
        .binaryTarget(name: "nanopb", path: "Firebase/FirebaseAnalytics/nanopb.xcframework"),
        /// Auth
        .binaryTarget(name: "GTMSessionFetcher", path: "Firebase/FirebaseAuth/GTMSessionFetcher.xcframework"),
        /// Firestore
        .binaryTarget(name: "BoringSSL-GRPC", path: "Firebase/FirebaseFirestore/BoringSSL-GRPC.xcframework"),
        .binaryTarget(name: "abseil", path: "Firebase/FirebaseFirestore/abseil.xcframework"),
        .binaryTarget(name: "gRPC-C++", path: "Firebase/FirebaseFirestore/gRPC-C++.xcframework"),
        .binaryTarget(name: "gRPC-Core", path: "Firebase/FirebaseFirestore/gRPC-Core.xcframework"),
        .binaryTarget(name: "leveldb-library", path: "Firebase/FirebaseFirestore/leveldb-library.xcframework"),
        
        /// 🧪 Tests
        .testTarget(
            name: "SpotrLogicTests",
            dependencies: ["SpotrLogic",],
            resources: [
                .process("./Resources/")
            ],
            linkerSettings: [
                .unsafeFlags(["-ObjC"])
            ]
        ),
    ]
)
