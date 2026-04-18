// Package.swift — Owner: Nguyen Hoang
// Swift Package Manager manifest. Only Nguyen adds new targets here.
// Everyone else creates .swift files directly in Finder — do NOT drag into Xcode.

// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "XRAdaptiveFitness",
    platforms: [
        .visionOS(.v1)
    ],
    targets: [
        .target(
            name: "XRAdaptiveFitness",
            path: "Sources/XRAdaptiveFitness"
        ),
        .testTarget(
            name: "XRAdaptiveFitnessTests",
            dependencies: ["XRAdaptiveFitness"],
            path: "Tests"
        )
    ]
)
