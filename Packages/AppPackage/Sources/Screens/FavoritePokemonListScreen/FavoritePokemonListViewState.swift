//
//  FavoritePokemonListViewState.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/19.
//

import Foundation
import GetPokemonListUseCase
import Observation
private import Dependencies
import Entity
import Logger

// MARK: - FavoritePokemonListViewState
@MainActor
@Observable
final class FavoritePokemonListViewState {

    @ObservationIgnored
    @Dependency(\.getPokemonListUseCase) private var getPokemonListUseCase

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
        pokemons.isEmpty
    }

    init() {}

    func getData() async {}

    func refresh() async {}
}
