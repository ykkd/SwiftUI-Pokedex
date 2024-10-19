//
//  FavoritePokemonListViewContainer+DependencyKey.swift
//  SwiftUI-Pokedex
//
//  Created by ykkd on 2024/10/19.
//

import Dependencies
import DependencyContainer
import FavoritePokemonListScreen
import Router
import SwiftUI

extension FavoritePokemonListViewContainer: @retroactive DependencyKey {

    public static var liveValue: Self {
        .init { router, input in
            AnyView(
                FavoritePokemonListView(router: router as! Router, input: input)
            )
        }
    }
}
