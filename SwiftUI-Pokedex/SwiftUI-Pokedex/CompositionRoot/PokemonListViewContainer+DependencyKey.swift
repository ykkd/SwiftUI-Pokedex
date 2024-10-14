//
//  PokemonListViewContainer+DependencyKey.swift
//  SwiftUI-Pokedex
//
//  Created by ykkd on 2024/10/15.
//

import Dependencies
import DependencyContainer
import PokemonListScreen
import Router
import SwiftUI

extension PokemonListViewContainer: @retroactive DependencyKey {

    public static var liveValue: Self {
        .init { router, input in
            AnyView(
                PokemonListView(router: router as! Router, input: input)
            )
        }
    }
}
