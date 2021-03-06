// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "MacSnapshottesting",
  platforms: [.macOS(.v11)],
  products: [
    .library(
      name: "MacSnapshottesting",
      targets: ["MacSnapshottesting"]),
  ],
  dependencies: [
    .package(
      name: "SnapshotTesting",
      url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
      from: "1.9.0"
    ),
  ],
  targets: [
    .target(
      name: "MacSnapshottesting",
      dependencies: []),
    .testTarget(
      name: "MacSnapshottestingTests",
      dependencies: ["MacSnapshottesting", "SnapshotTesting"],
      exclude: ["__Snapshots__"]
    )
  ]
)
