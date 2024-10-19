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

    private(set) var isFavorited: Bool = false {
        didSet {
            logger.log(.debug, message: "isFavorited: \(oldValue) to \(isFavorited)")
        }
    }

    private var favorable: FavorablePokemon? {
        if let pokemonDetail {
            .init(pokemon:
                .init(
                    name: pokemonDetail.name,
                    number: pokemonDetail.number,
                    imageUrl: pokemonDetail.imageUrl,
                    subImageUrl: pokemonDetail.subImageUrl
                ),
                isFavorite: isFavorited
            )
        } else {
            nil
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
            try await getIsFavorited()
            try await updatePokemonDetail()
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

    func updateIsFavorited(_ value: Bool) async {
        do {
            try await saveIsFavorited(value)
        } catch {
            // TODO: implement
        }
    }
}

// MARK: - Private
extension PokemonDetailViewState {

    private func updatePokemonDetail() async throws {
        let data = try await getPokemonDetailUseCase.execute(pokemonNumber)
        pokemonDetail = data
    }

    private func getIsFavorited() async throws {
        if let data = try await getFavoritePokemonUseCase.execute(pokemonNumber) {
            isFavorited = await data.isFavorite
        } else {
            isFavorited = false
        }
    }

    private func saveIsFavorited(_ isFavorite: Bool) async throws {
        isFavorited = isFavorite
        guard let favorable else {
            return
        }
        try await saveFavoritePokemonUseCase.execute(favorable)
    }
}
