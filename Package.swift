// swift-tools-version: 6.4
import PackageDescription

let package = Package(
    name: "swift-ball",
    platforms: [.macOS(.v27), .iOS(.v27), .tvOS(.v27), .watchOS(.v27), .visionOS(.v27)],
    products: [.library(name: "Ball", targets: ["Ball"])],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-magnitude.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-point.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-tagged.git", branch: "main"),
    ],
    targets: [
        .target(name: "Ball", dependencies: [
            .product(name: "Magnitude", package: "swift-magnitude"),
        ]),
        .testTarget(name: "Ball Tests", dependencies: [
            .target(name: "Ball"),
            .product(name: "Point", package: "swift-point"),
            .product(name: "Tagged", package: "swift-tagged"),
        ]),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
