//
//  PokemonAggregate.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/14.
//

import Foundation

public struct PokemonAggregate {

    public let totalCount: Int
    public let pokemons: [Pokemon]

    public init(totalCount: Int, pokemons: [Pokemon]) {
        self.totalCount = totalCount
        self.pokemons = pokemons
    }
}
