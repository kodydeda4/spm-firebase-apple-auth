// swift-tools-version: 5.6

import PackageDescription

let package = Package(
  name: "SimplifySignInWithApple",
  platforms: [.macOS(.v12), .iOS(.v14), .watchOS(.v7)],
  products: [
    .library(name: "SimplifySignInWithApple", targets: ["SimplifySignInWithApple"]),
  ],
  dependencies: [],
  targets: [
    .target(name: "SimplifySignInWithApple", dependencies: [])
  ]
)
