// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.


import PackageDescription

let package = Package(
    name: "Appgain",
   // platforms: [.iOS(.v10), .macOS(.v10_12), .tvOS(.v10), .watchOS(.v3)],
    products: [
        .library(name: "Appgain", targets: ["Appgain"]),
        .library(name: "Appgain-rich", targets: ["Appgian-rich"]),
        
    ],
    targets: [
        .target(
            name: "Appgain",
            path: "Sources",
            exclude: ["Appgain-rich"]
        ),
        .target(
            name: "Appgain-rich",
            dependencies: ["Appgain"],
            path: "Sources",
            sources: ["Appgain-rich"]
        )
    ]
)
