//
//  PokemonDetailViewContainer.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/17.
//

import Dependencies
import Entity
import RouterCore
import SwiftUI

// MARK: - PokemonDetailViewContainer
public struct PokemonDetailViewContainer: Sendable {

    public var view: @MainActor @Sendable (
        _ router: BaseRouter,
        _ input: CommonScreenInput,
        _ pokemonNumber: Int
    ) -> AnyView

    public init(
        view: @escaping @MainActor @Sendable (
            _ router: BaseRouter,
            _ input: CommonScreenInput,
            _ pokemonNumber: Int
        ) -> AnyView
    ) {
        self.view = view
    }
}

// MARK: TestDependencyKey
extension PokemonDetailViewContainer: TestDependencyKey {

    public static var testValue: Self {
        .init(view: unimplemented("", placeholder: AnyView(Text("TestValue of PokemonDetailView"))))
    }
}

extension DependencyValues {

    public var pokemonDetailViewContainer: PokemonDetailViewContainer {
        get { self[PokemonDetailViewContainer.self] }
        set { self[PokemonDetailViewContainer.self] = newValue }
    }
}
