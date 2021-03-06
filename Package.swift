// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.


import PackageDescription

let package = Package(
    name: "Appgain",
   // platforms: [.iOS(.v10), .macOS(.v10_12), .tvOS(.v10), .watchOS(.v3)],
    products: [
        .library(name: "Appgain", targets: ["Appgain"]),
        .library(name: "Appgain-rich", targets: ["Appgain-rich"]),
        
    ],
    targets: [
        .target(
            name: "Appgain",
            path: "Sources"
        ),
        .target(
            name: "Appgain-rich",
            path: "Sources-rich"
        )
    ]
)
