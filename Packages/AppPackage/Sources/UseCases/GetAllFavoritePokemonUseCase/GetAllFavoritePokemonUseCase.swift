//
//  GetAllFavoritePokemonUseCase.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/20.
//

import Dependencies
import Entity
import Foundation
private import SwiftDataWrapper

// MARK: - GetAllFavoritePokemonUseCase
public struct GetAllFavoritePokemonUseCase: Sendable {

    @Dependency(\.pokemonSwiftDataWrapperContainer) private var pokemonSwiftDataWrapperContainer

    public func execute() async throws(ApplicationError) -> [FavorablePokemon] {
        try await pokemonSwiftDataWrapperContainer.container().readAllPokemon()
    }
}

// MARK: DependencyKey
extension GetAllFavoritePokemonUseCase: DependencyKey {

    public static var liveValue: Self {
        GetAllFavoritePokemonUseCase()
    }
}

extension DependencyValues {

    public var getAllFavoritePokemonUseCase: GetAllFavoritePokemonUseCase {
        get { self[GetAllFavoritePokemonUseCase.self] }
        set { self[GetAllFavoritePokemonUseCase.self] = newValue }
    }
}
