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
    case pokeAPIClientWrapper

    var targets: [String] {
        Targets.targets(for: self)
    }

    var value: Product {
        Product.library(
            name: capitalizedName,
            targets: targets
        )
    }
}

// MARK: - Dependencies
enum Dependencies: String, CaseIterable, PackageAtom {
    case swiftLint
    case swiftDependencies = "swift-dependencies"
    case swiftOpenAPIGenerater = "swift-openapi-generator"
    case swiftOpenAPIRuntime = "swift-openapi-runtime"
    case swiftOpenAPIUrlSession = "swift-openapi-urlsession"

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
        case .swiftOpenAPIGenerater:
            .package(
                url: "https://github.com/apple/swift-openapi-generator", .upToNextMajor(from: "1.0.0")
            )
        case .swiftOpenAPIRuntime:
            .package(
                url: "https://github.com/apple/swift-openapi-runtime", .upToNextMajor(from: "1.0.0")
            )
        case .swiftOpenAPIUrlSession:
            .package(
                url: "https://github.com/apple/swift-openapi-urlsession", .upToNextMajor(from: "1.0.0")
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
    case pokeAPIClientWrapper

    var targetType: TargetType {
        switch self {
        case .dependencyContainer,
             .entity,
             .routerCore,
             .rootScreen,
             .router,
             .pokeAPIClientWrapper:
            .production
        }
    }

    var pathName: String {
        switch self {
        case .dependencyContainer,
             .entity:
            "\(capitalizedName)"
        case .routerCore,
             .router:
            "Router/\(capitalizedName)"
        case .rootScreen:
            "Screens/\(capitalizedName)"
        case .pokeAPIClientWrapper:
            "Wrappers/\(capitalizedName)"
        }
    }

    var dependencies: [Target.Dependency] {
        switch self {
        case .entity:
            []
        case .dependencyContainer:
            [
                Dependencies.swiftDependencies.asDependency(productName: .specified(name: "Dependencies")),
                Targets.entity.asDependency,
                Targets.routerCore.asDependency,
            ]
        case .routerCore:
            [
                Targets.entity.asDependency,
            ]
        case .router:
            [
                Dependencies.swiftDependencies.asDependency(productName: .specified(name: "Dependencies")),
                Targets.dependencyContainer.asDependency,
                Targets.routerCore.asDependency,
            ]
        case .rootScreen:
            [
                Targets.entity.asDependency,
                Targets.router.asDependency,
                Targets.dependencyContainer.asDependency,
                Dependencies.swiftDependencies.asDependency(productName: .specified(name: "Dependencies")),
            ]
        case .pokeAPIClientWrapper:
            [
                Dependencies.swiftOpenAPIRuntime.asDependency(productName: .specified(name: "OpenAPIRuntime")),
                Dependencies.swiftOpenAPIUrlSession.asDependency(productName: .specified(name: "OpenAPIURLSession")),
                Targets.entity.asDependency,
            ]
        }
    }

    var plugins: [Target.PluginUsage] {
        switch self {
        case .pokeAPIClientWrapper:
            [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint"),
                .plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator"),
            ]
        default:
            [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint"),
            ]
        }
    }

    var value: Target {
        switch targetType {
        case .production:
            .target(
                name: capitalizedName,
                dependencies: dependencies,
                path: "./Sources/\(pathName)",
                swiftSettings: swiftSettings,
                plugins: plugins
            )
        case .test:
            .testTarget(
                name: capitalizedName,
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
        Targets.allCases.map(\.capitalizedName).filter { $0 == product.capitalizedName }
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
        rawValue
    }

    var capitalizedName: String {
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
