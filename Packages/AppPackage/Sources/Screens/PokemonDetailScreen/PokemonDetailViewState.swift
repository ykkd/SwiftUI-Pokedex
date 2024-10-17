//
//  PokemonDetailViewState.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/17.
//

import Foundation
import Observation
private import Dependencies
import Entity
import Logger

// MARK: - PokemonDetailViewState
@MainActor
@Observable
final class PokemonDetailViewState {

    let pokemonNumber: Int

    @ObservationIgnored
    @Dependency(\.mainLogger) private var logger

    private(set) var isLoading: Bool = false {
        didSet {
            logger.log(.debug, message: "isLoading: \(isLoading)")
        }
    }

    init(pokemonNumber: Int) {
        self.pokemonNumber = pokemonNumber
    }
}
