//
//  GetPokemonDetailUseCase.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/17.
//

import Dependencies
import Entity
import Foundation
import PokeAPIClientWrapper

// MARK: - GetPokemonDetailUseCase
public struct GetPokemonDetailUseCase: Sendable {

    @Dependency(\.pokeAPIClientWrapper) private var pokeAPIClientWrapper

    public func execute(_ number: Int) async throws(ApplicationError) -> PokemonDetail {
        try await pokeAPIClientWrapper.getPokemonDetail(number)
    }
}

// MARK: DependencyKey
extension GetPokemonDetailUseCase: DependencyKey {

    public static var liveValue: Self {
        GetPokemonDetailUseCase()
    }
}

extension DependencyValues {

    public var getPokemonDetailUseCase: GetPokemonDetailUseCase {
        get { self[GetPokemonDetailUseCase.self] }
        set { self[GetPokemonDetailUseCase.self] = newValue }
    }
}
