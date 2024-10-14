//
//  PokemonAggregate.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/14.
//

import Foundation

public struct PokemonAggregate {

    public let count: Int
    public let pokemons: [Pokemon]

    public init(count: Int, pokemons: [Pokemon]) {
        self.count = count
        self.pokemons = pokemons
    }
}
