// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MyFirstSwiftPackage",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MyFirstSwiftPackage",
            targets: ["MyFirstSwiftPackage"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.7.1")
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "MyFirstSwiftPackage",
            dependencies: ["Alamofire"],
            path: "Sources/CoreData",
            resources: [.process("CoreData/LoggerModel.xcdatamodeld")]),
        .testTarget(
            name: "MyFirstSwiftPackageTests",
            dependencies: ["MyFirstSwiftPackage"]),
    ]
)
