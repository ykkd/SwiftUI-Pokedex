// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Pacakge
let package = Package(
    name: "AppPackage",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: Products.allValues,
    dependencies: Dependencies.allValues,
    targets: Targets.allValues
)

// MARK: - Settings
let otherSwiftFlagsForDebug = [
    "-Xfrontend", "-warn-long-expression-type-checking=500",
    "-Xfrontend", "-warn-long-function-bodies=500",
]

let swiftSettings: [PackageDescription.SwiftSetting] = [
    .unsafeFlags(otherSwiftFlagsForDebug, .when(configuration: .debug)),
]

// MARK: - Products
enum Products: String, CaseIterable, PackageAtom {
    case dependencyContainer
    case entity
    case routerCore
    case router
    case rootScreen

    var targets: [String] {
        Targets.targets(for: self)
    }

    var value: Product {
        Product.library(
            name: name,
            targets: targets
        )
    }
}

// MARK: - Dependencies
enum Dependencies: String, CaseIterable, PackageAtom {
    case swiftLint
    case swiftDependencies = "swift-dependencies"

    var value: Package.Dependency {
        switch self {
        case .swiftLint:
            .package(
                url: "https://github.com/realm/SwiftLint.git",
                from: "0.57.0"
            )
        case .swiftDependencies:
            .package(
                url: "https://github.com/pointfreeco/swift-dependencies.git", .upToNextMajor(from: "1.4.1")
            )
        }
    }

    func asDependency(productName: ProductName) -> Target.Dependency {
        switch productName {
        case let .specified(moduleName):
            .product(name: moduleName, package: name)
        case .usePackageName:
            .product(name: name, package: name)
        }
    }

    enum ProductName {
        case specified(name: String)
        case usePackageName
    }
}

// MARK: - Targets
enum Targets: String, CaseIterable, PackageAtom {
    case dependencyContainer
    case entity
    case routerCore
    case router
    case rootScreen

    var targetType: TargetType {
        switch self {
        case .dependencyContainer,
             .entity,
             .routerCore,
             .rootScreen,
             .router:
            .production
        }
    }

    var pathName: String {
        switch self {
        case .dependencyContainer,
             .entity:
            "\(name)"
        case .routerCore,
             .router:
            "Router/\(name)"
        case .rootScreen:
            "Screens/\(name)"
        }
    }

    var dependencies: [Target.Dependency] {
        switch self {
        case .dependencyContainer:
            [
                Dependencies.swiftDependencies.asDependency(productName: .specified(name: "Dependencies")),
            ]
        case .routerCore:
            [
                Targets.entity.asDependency,
            ]
        case .router:
            [
                Targets.routerCore.asDependency,
            ]
        case .entity,
             .rootScreen:
            []
        }
    }

    var plugins: [Target.PluginUsage] {
        [
            .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint"),
        ]
    }

    var value: Target {
        switch targetType {
        case .production:
            .target(
                name: name,
                dependencies: dependencies,
                path: "./Sources/\(pathName)",
                swiftSettings: swiftSettings,
                plugins: plugins
            )
        case .test:
            .testTarget(
                name: name,
                dependencies: dependencies,
                path: "./Tests/\(pathName)",
                swiftSettings: swiftSettings,
                plugins: plugins
            )
        }
    }

    var asDependency: Target.Dependency {
        .target(name: value.name)
    }

    static func targets(for product: Products) -> [String] {
        Targets.allCases.map(\.name).filter { $0 == product.name }
    }
}

// MARK: - PackageAtom
protocol PackageAtom {
    associatedtype ValueType

    var name: String { get }
    var value: ValueType { get }
}

extension PackageAtom where Self: RawRepresentable, Self.RawValue == String {

    var name: String {
        rawValue.initialLetterUppercased()
    }
}

extension PackageAtom where Self: CaseIterable {

    static var allValues: [ValueType] {
        allCases.map(\.value)
    }
}

extension String {

    func initialLetterUppercased() -> Self {
        prefix(1).uppercased() + dropFirst()
    }
}

// MARK: - Targets.TargetType
extension Targets {

    enum TargetType {
        case production
        case test

        var isTestTarget: Bool {
            self == .test
        }
    }
}
