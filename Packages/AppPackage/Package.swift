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
    case logger
    case routerCore
    case router
    case getPokemonListUseCase
    case getPokemonDetailUseCase
    case getFavoritePokemonUseCase
    case getAllFavoritePokemonUseCase
    case saveFavoritePokemonUseCase
    case rootScreen
    case alertScreen
    case pokemonListScreen
    case pokemonDetailScreen
    case favoritePokemonListScreen
    case pokeAPIClientWrapper
    case swiftDataWrapper
    case designSystem
    case sharedExtension
    case screenExtension

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
    case sfSafeSymbols = "SFSafeSymbols"
    case refreshable = "Refreshable"

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
        case .sfSafeSymbols:
            .package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols.git", .upToNextMajor(from: "5.3.0")
            )
        case .refreshable:
            .package(
                url: "https://github.com/c-villain/Refreshable.git", .upToNextMajor(from: "0.2.0")
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
    case logger
    case routerCore
    case router
    case getPokemonListUseCase
    case getPokemonDetailUseCase
    case getFavoritePokemonUseCase
    case getAllFavoritePokemonUseCase
    case saveFavoritePokemonUseCase
    case rootScreen
    case alertScreen
    case pokemonListScreen
    case pokemonDetailScreen
    case favoritePokemonListScreen
    case pokeAPIClientWrapper
    case swiftDataWrapper
    case designSystem
    case sharedExtension
    case screenExtension

    var targetType: TargetType {
        switch self {
        case .dependencyContainer,
             .entity,
             .logger,
             .routerCore,
             .router,
             .getPokemonListUseCase,
             .getPokemonDetailUseCase,
             .getFavoritePokemonUseCase,
             .getAllFavoritePokemonUseCase,
             .saveFavoritePokemonUseCase,
             .rootScreen,
             .alertScreen,
             .pokemonListScreen,
             .pokemonDetailScreen,
             .favoritePokemonListScreen,
             .pokeAPIClientWrapper,
             .designSystem,
             .sharedExtension,
             .screenExtension,
             .swiftDataWrapper:
            .production
        }
    }

    static var commonDependenciesForScreen: [Target.Dependency] {
        [
            Dependencies.swiftDependencies.asDependency(productName: .specified(name: "Dependencies")),
            Targets.entity.asDependency,
            Targets.router.asDependency,
            Targets.dependencyContainer.asDependency,
            Targets.designSystem.asDependency,
            Dependencies.sfSafeSymbols.asDependency(productName: .usePackageName),
            Targets.screenExtension.asDependency,
            Targets.logger.asDependency,
        ]
    }

    var pathName: String {
        switch self {
        case .dependencyContainer,
             .entity,
             .logger,
             .designSystem:
            "\(capitalizedName)"
        case .routerCore,
             .router:
            "Router/\(capitalizedName)"
        case .getPokemonListUseCase,
             .getPokemonDetailUseCase,
             .getFavoritePokemonUseCase,
             .getAllFavoritePokemonUseCase,
             .saveFavoritePokemonUseCase:
            "UseCases/\(capitalizedName)"
        case .rootScreen,
             .alertScreen,
             .pokemonListScreen,
             .pokemonDetailScreen,
             .favoritePokemonListScreen:
            "Screens/\(capitalizedName)"
        case .pokeAPIClientWrapper,
             .swiftDataWrapper:
            "Wrappers/\(capitalizedName)"
        case .sharedExtension,
             .screenExtension:
            "Extension/\(capitalizedName)"
        }
    }

    var dependencies: [Target.Dependency] {
        switch self {
        case .sharedExtension:
            []
        case .entity,
             .screenExtension:
            [
                Targets.sharedExtension.asDependency,
            ]
        case .designSystem:
            [
                Targets.sharedExtension.asDependency,
                Dependencies.refreshable.asDependency(productName: .usePackageName),
            ]
        case .logger:
            [
                Targets.sharedExtension.asDependency,
                Dependencies.swiftDependencies.asDependency(productName: .specified(name: "Dependencies")),
            ]
        case .dependencyContainer:
            [
                Targets.sharedExtension.asDependency,
                Dependencies.swiftDependencies.asDependency(productName: .specified(name: "Dependencies")),
                Targets.entity.asDependency,
                Targets.routerCore.asDependency,
            ]
        case .routerCore:
            [
                Targets.sharedExtension.asDependency,
                Targets.entity.asDependency,
            ]
        case .router:
            [
                Targets.sharedExtension.asDependency,
                Dependencies.swiftDependencies.asDependency(productName: .specified(name: "Dependencies")),
                Targets.dependencyContainer.asDependency,
                Targets.routerCore.asDependency,
            ]
        case .getPokemonListUseCase,
             .getPokemonDetailUseCase:
            [
                Targets.sharedExtension.asDependency,
                Dependencies.swiftDependencies.asDependency(productName: .specified(name: "Dependencies")),
                Targets.entity.asDependency,
                Targets.pokeAPIClientWrapper.asDependency,
            ]
        case .getFavoritePokemonUseCase,
             .getAllFavoritePokemonUseCase,
             .saveFavoritePokemonUseCase:
            [
                Targets.sharedExtension.asDependency,
                Dependencies.swiftDependencies.asDependency(productName: .specified(name: "Dependencies")),
                Targets.entity.asDependency,
                Targets.swiftDataWrapper.asDependency,
            ]
        case .rootScreen,
             .alertScreen:
            Self.commonDependenciesForScreen + [
                Targets.sharedExtension.asDependency,
            ]
        case .pokemonListScreen:
            Self.commonDependenciesForScreen + [
                Targets.sharedExtension.asDependency,
                Targets.getPokemonListUseCase.asDependency,
            ]
        case .pokemonDetailScreen:
            Self.commonDependenciesForScreen + [
                Targets.getPokemonDetailUseCase.asDependency,
                Targets.sharedExtension.asDependency,
                Targets.saveFavoritePokemonUseCase.asDependency,
                Targets.getFavoritePokemonUseCase.asDependency,
            ]
        case .favoritePokemonListScreen:
            Self.commonDependenciesForScreen + [
                Targets.sharedExtension.asDependency,
                Targets.getAllFavoritePokemonUseCase.asDependency,
            ]
        case .pokeAPIClientWrapper:
            [
                Targets.sharedExtension.asDependency,
                Dependencies.swiftOpenAPIRuntime.asDependency(productName: .specified(name: "OpenAPIRuntime")),
                Dependencies.swiftOpenAPIUrlSession.asDependency(productName: .specified(name: "OpenAPIURLSession")),
                Dependencies.swiftDependencies.asDependency(productName: .specified(name: "Dependencies")),
                Targets.entity.asDependency,
            ]
        case .swiftDataWrapper:
            [
                Dependencies.swiftDependencies.asDependency(productName: .specified(name: "Dependencies")),
                Targets.sharedExtension.asDependency,
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
