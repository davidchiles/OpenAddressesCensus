import PackageDescription

let package = Package(
    name: "OpenAddressesCensus",
    dependencies: [
        .Package(url: "https://github.com/Daniel1of1/CSwiftV.git", majorVersion: 0)
    ]
)