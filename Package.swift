// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "HorusApp",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .executable(
            name: "HorusApp",
            targets: ["HorusApp"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/mxcl/SwiftTerm.git", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "HorusApp",
            dependencies: [
                .product(name: "SwiftTerm", package: "SwiftTerm")
            ],
            path: "HorusApp",
            exclude: ["Info.plist"],
            resources: [
                .process("Resources")
            ]
        )
    ]
)