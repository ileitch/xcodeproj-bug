// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "XcodeprojBug",
    products: [
        .executable(name: "test", targets: ["Code"])
    ],
    dependencies: [
        .package(url: "https://github.com/tuist/xcodeproj", from: "6.0.0"),
    ],
    targets: [
        .target(
            name: "Code",
            dependencies: [
                "xcodeproj",
            ]
        ),
    ],
    swiftLanguageVersions: [.v4_2]
)
