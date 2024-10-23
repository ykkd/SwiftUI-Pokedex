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
private import GetFavoritePokemonUseCase
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
    @Dependency(\.getFavoritePokemonUseCase) private var getFavoritePokemonUseCase

    @ObservationIgnored
    @Dependency(\.saveFavoritePokemonUseCase) private var saveFavoritePokemonUseCase

    private(set) var contentId: UUID = .init()

    private(set) var isLoading: Bool = false {
        didSet {
            logger.log(.debug, message: "isLoading: \(isLoading)")
        }
    }

    private(set) var pokemonDetail: PokemonDetail? {
        didSet {
            logger.log(.debug, message: "pokemonDetail: \(String(describing: pokemonDetail))")
        }
    }

    private(set) var isFavorite: Bool = false {
        didSet {
            logger.log(.debug, message: "isFavorited: \(oldValue) to \(isFavorite)")
        }
    }

    private(set) var isBgAniationStarted: Bool = false

    let pokemonNumber: Int

    var shouldShowEmptyView: Bool {
        pokemonDetail == nil
    }

    var numberText: String {
        "No.\(pokemonNumber)"
    }

    init(pokemonNumber: Int) {
        self.pokemonNumber = pokemonNumber
    }

    func getPokemonDetail() async throws(ApplicationError) {
        defer { isLoading = false }
        isLoading = true
        try await getIsFavorite()
        try await updatePokemonDetail()
    }

    func refresh() async throws(ApplicationError) {
        try await getPokemonDetail()
        contentId = .init()
    }

    func updateIsBgAniationStarted(_ value: Bool) {
        isBgAniationStarted = value
    }

    func updateIsFavorite(_ value: Bool) async throws(ApplicationError) {
        try await saveIsFavorite(value)
    }
}

// MARK: - Private
extension PokemonDetailViewState {

    private func updatePokemonDetail() async throws(ApplicationError) {
        let data = try await getPokemonDetailUseCase.execute(pokemonNumber)
        pokemonDetail = data
    }

    private func getIsFavorite() async throws(ApplicationError) {
        if let data = try await getFavoritePokemonUseCase.execute(pokemonNumber) {
            isFavorite = await data.isFavorite
        } else {
            isFavorite = false
        }
    }

    private func saveIsFavorite(_ value: Bool) async throws(ApplicationError) {
        guard let favorable = ViewLogic.generateFavorablePokemon(pokemonDetail, isFavorite: value) else {
            return
        }
        try await saveFavoritePokemonUseCase.execute(favorable)
        isFavorite = value
    }
}
