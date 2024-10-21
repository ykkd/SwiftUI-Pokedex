//
//  FavoritePokemonListViewState.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/19.
//

import Foundation
private import GetAllFavoritePokemonUseCase
import Observation
private import Dependencies
import Entity
import Logger

// MARK: - FavoritePokemonListViewState
@MainActor
@Observable
final class FavoritePokemonListViewState {

    @ObservationIgnored
    @Dependency(\.getAllFavoritePokemonUseCase) private var getAllFavoritePokemonUseCase

    @ObservationIgnored
    @Dependency(\.mainLogger) private var logger

    private(set) var pokemons: [Pokemon] = [] {
        didSet {
            logger.log(.debug, message: "number of pokemons: \(pokemons.count)")
        }
    }

    private(set) var isLoading: Bool = false {
        didSet {
            logger.log(.debug, message: "isLoading: \(isLoading)")
        }
    }

    var shouldShowEmptyView: Bool {
        pokemons.isEmpty && !isLoading
    }

    init() {}

    func getData() async throws(ApplicationError) {
        defer { isLoading = false }
        isLoading = true
        let favorablePokemons = try await getAllFavoritePokemonUseCase.execute()

        var favoritedPokemons: [Pokemon] = []

        for data in favorablePokemons where await data.getIsFavorite() {
            favoritedPokemons.append(data.pokemon)
        }
        pokemons = favoritedPokemons
    }

    func refresh() async throws(ApplicationError) {
        try await getData()
    }
}
