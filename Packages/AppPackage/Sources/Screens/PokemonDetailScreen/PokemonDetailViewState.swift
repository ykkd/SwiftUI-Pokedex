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
import GetPokemonDetailUseCase
import Logger

// MARK: - PokemonDetailViewState
@MainActor
@Observable
final class PokemonDetailViewState {

    @ObservationIgnored
    @Dependency(\.mainLogger) private var logger

    @ObservationIgnored
    @Dependency(\.getPokemonDetailUseCase) private var getPokemonDetailUseCase

    private(set) var isLoading: Bool = false {
        didSet {
            logger.log(.debug, message: "isLoading: \(isLoading)")
        }
    }

    private(set) var pokemonDetail: PokemonDetail? {
        didSet {
            logger.log(.debug, message: "pokemonDetail: \(pokemonDetail)")
        }
    }

    let pokemonNumber: Int

    var shouldShowEmptyView: Bool {
        pokemonDetail == nil
    }

    init(pokemonNumber: Int) {
        self.pokemonNumber = pokemonNumber
    }

    func getPokemonDetail() async {
        defer { isLoading = false }
        do {
            isLoading = true
            let data = try await getPokemonDetailUseCase.execute(pokemonNumber)
            pokemonDetail = data
        } catch {
            // TODO: implement
        }
    }

    func refresh() async {
        await getPokemonDetail()
    }
}
