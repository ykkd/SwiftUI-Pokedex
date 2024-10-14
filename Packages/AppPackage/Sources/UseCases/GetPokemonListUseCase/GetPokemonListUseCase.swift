//
//  GetPokemonListUseCase.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/14.
//

import Dependencies
import Entity
import Foundation
import PokeAPIClientWrapper

// MARK: - GetPokemonListUseCase
public struct GetPokemonListUseCase: Sendable {

    @Dependency(\.pokeAPIClientWrapper) private var pokeAPIClientWrapper

    public func execute(_ limit: Int, offset: Int) async throws(ApplicationError) -> PokemonAggregate {
        try await pokeAPIClientWrapper.getPokemonList(limit: limit, offset: offset)
    }
}

// MARK: DependencyKey
extension GetPokemonListUseCase: DependencyKey {

    public static var liveValue: Self {
        GetPokemonListUseCase()
    }
}

extension DependencyValues {

    public var getPokemonListUseCase: GetPokemonListUseCase {
        get { self[GetPokemonListUseCase.self] }
        set { self[GetPokemonListUseCase.self] = newValue }
    }
}
