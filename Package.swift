// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "VeloraAppleThemes",
    platforms: [.iOS(.v17), .macOS(.v14), .tvOS(.v17), .watchOS(.v10), .visionOS(.v1)],
    products: [.library(name: "VeloraAppleThemes", targets: ["VeloraAppleThemes"])],
    targets: [
        .target(
            name: "VeloraAppleThemes",
            path: ".",
            exclude: ["SwiftTests", "tests", "scripts", ".github", "README.md", "THEME_API.md", "LICENSE", "upstream.json"],
            sources: ["Sources/VeloraAppleThemes"],
            resources: [.copy("themes"), .copy("catalog.json")]
        ),
        .testTarget(name: "VeloraAppleThemesTests", dependencies: ["VeloraAppleThemes"], path: "SwiftTests/VeloraAppleThemesTests")
    ]
)
