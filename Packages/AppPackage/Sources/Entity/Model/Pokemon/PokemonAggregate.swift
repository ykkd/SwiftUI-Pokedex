//
//  PokemonAggregate.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/14.
//

import Foundation

// MARK: - PokemonAggregate
public struct PokemonAggregate: Sendable {

    public let totalCount: Int
    public let pokemons: [Pokemon]

    public init(totalCount: Int, pokemons: [Pokemon]) {
        self.totalCount = totalCount
        self.pokemons = pokemons
    }
}

extension PokemonAggregate {

    public static var empty: Self {
        .init(totalCount: 0, pokemons: [])
    }
}
