// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapgoCapacitorPersistentUuid",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "CapgoCapacitorPersistentUuid",
            targets: ["PersistentUuidPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "8.0.0")
    ],
    targets: [
        .target(
            name: "PersistentUuidPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/PersistentUuidPlugin"),
        .testTarget(
            name: "PersistentUuidPluginTests",
            dependencies: ["PersistentUuidPlugin"],
            path: "ios/Tests/PersistentUuidPluginTests")
    ]
)
