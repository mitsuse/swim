import PackageDescription

let package = Package(
    name: "swim",
    dependencies: [
        .Package(
            url: "https://github.com/Carthage/Commandant.git",
            majorVersion: 0,
            minor: 11
        ),
    ]
)
