//
//  PokemonDetailViewContainer+DependencyKey.swift
//  SwiftUI-Pokedex
//
//  Created by ykkd on 2024/10/17.
//

import Dependencies
import DependencyContainer
import PokemonDetailScreen
import Router
import SwiftUI

extension PokemonDetailViewContainer: @retroactive DependencyKey {

    public static var liveValue: Self {
        .init { router, input, pokemonNumber in
            AnyView(
                PokemonDetailView(router: router as! Router, input: input, pokemonNumber: pokemonNumber)
            )
        }
    }
}
