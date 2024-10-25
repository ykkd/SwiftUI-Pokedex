//
//  SaveFavoritePokemonUseCase.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/20.
//

import Dependencies
import Entity
import Foundation
private import SwiftDataWrapper

// MARK: - SaveFavoritePokemonUseCase
public struct SaveFavoritePokemonUseCase: Sendable {

    @Dependency(\.pokemonSwiftDataWrapperContainer) private var pokemonSwiftDataWrapperContainer

    public func execute(_ pokemon: FavorablePokemon) async throws(ApplicationError) {
        try await pokemonSwiftDataWrapperContainer.container().writePokemon(pokemon)
    }
}

// MARK: DependencyKey
extension SaveFavoritePokemonUseCase: DependencyKey {

    public static var liveValue: Self {
        SaveFavoritePokemonUseCase()
    }
}

extension DependencyValues {

    public var saveFavoritePokemonUseCase: SaveFavoritePokemonUseCase {
        get { self[SaveFavoritePokemonUseCase.self] }
        set { self[SaveFavoritePokemonUseCase.self] = newValue }
    }
}
