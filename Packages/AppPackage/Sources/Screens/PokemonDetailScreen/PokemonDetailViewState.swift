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
private import GetPokemonDetailUseCase
private import SaveFavoritePokemonUseCase
import Logger

// MARK: - PokemonDetailViewState
@MainActor
@Observable
final class PokemonDetailViewState {

    @ObservationIgnored
    @Dependency(\.mainLogger) private var logger

    @ObservationIgnored
    @Dependency(\.getPokemonDetailUseCase) private var getPokemonDetailUseCase

    @ObservationIgnored
    @Dependency(\.saveFavoritePokemonUseCase) private var saveFavoritePokemonUseCase

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

    private(set) var isBgAniationStarted: Bool = false

    var shouldShowEmptyView: Bool {
        pokemonDetail == nil
    }

    var sections: [PokemonDetailViewSection] {
        [.mainVisual, .description, .status, .information]
    }

    var numberText: String {
        "No.\(pokemonNumber)"
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

    func updateIsBgAniationStarted(_ value: Bool) {
        isBgAniationStarted = value
    }
}
