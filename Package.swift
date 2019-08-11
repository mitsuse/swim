// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "swim",
    platforms: [
        .macOS(.v10_14),
    ],
    products: [
        .executable(name: "swim", targets: ["swim"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Carthage/Commandant.git", "0.17.0"..<"0.18.0"),
    ],
    targets: [
        .target(
            name: "swim",
            dependencies: [
                "Commandant"
            ]
        )
    ]
)
