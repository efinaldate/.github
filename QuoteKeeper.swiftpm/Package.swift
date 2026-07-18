// swift-tools-version: 5.9

// This is a Swift Playgrounds "App" package. It is meant to be opened and run
// inside the Swift Playgrounds app on iPhone or iPad. The `AppleProductTypes`
// module and the `.iOSApplication` product below only exist inside Swift
// Playgrounds, so this file will not build with plain command-line SwiftPM —
// that's expected.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "QuoteKeeper",
    platforms: [
        .iOS("17.0")
    ],
    products: [
        .iOSApplication(
            name: "QuoteKeeper",
            targets: ["AppModule"],
            bundleIdentifier: "com.curtisn.quotekeeper",
            teamIdentifier: "",
            displayVersion: "1.0",
            bundleVersion: "1",
            accentColor: .presetColor(.indigo),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: "."
        )
    ]
)
