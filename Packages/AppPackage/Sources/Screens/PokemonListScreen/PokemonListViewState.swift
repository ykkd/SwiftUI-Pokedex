//
//  PokemonListViewState.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/15.
//

import Foundation
import GetPokemonListUseCase
import Observation
private import Dependencies
import Entity
import Logger

// MARK: - PokemonListViewState
@MainActor
@Observable
final class PokemonListViewState {

    @ObservationIgnored
    @Dependency(\.getPokemonListUseCase) private var getPokemonListUseCase

    @ObservationIgnored
    @Dependency(\.mainLogger) private var logger

    private let limitPerPage: Int = 50

    private(set) var totalCount: Int = .zero

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

    private var limitForRefresh: Int {
        if pokemons.count != .zero {
            pokemons.count
        } else {
            limitPerPage
        }
    }

    var shouldShowBottomProgress: Bool {
        guard totalCount != .zero,
              !pokemons.isEmpty else {
            return false
        }
        return pokemons.count == totalCount || !isLoading
    }

    var shouldShowEmptyView: Bool {
        pokemons.isEmpty
    }

    init() {}

    func getInitialData() async throws(ApplicationError) {
        try await getData(limitPerPage, offset: .zero)
    }

    func refresh() async throws(ApplicationError) {
        try await getInitialData()
    }

    func getNextPageIfNeeded(last pokemon: Pokemon) async throws(ApplicationError) {
        guard pokemons.last == pokemon,
              totalCount != pokemons.count else {
            return
        }
        try await getData(limitPerPage, offset: pokemon.number + 1)
    }
}

extension PokemonListViewState {

    private func getData(_ limit: Int, offset: Int) async throws(ApplicationError) {
        defer { isLoading = false }

        isLoading = true
        let data = try await getPokemonListUseCase.execute(limit, offset: offset)
        totalCount = data.totalCount
        // 新しいポケモンを追加
        let newPokemons = data.pokemons

        // 既存のポケモンと新しいポケモンを統合
        var uniquePokemonsDict = Dictionary(uniqueKeysWithValues: pokemons.map { ($0.id, $0) }) // idをキーにしてユニークな辞書を作成

        // 新しいポケモンを追加
        for pokemon in newPokemons {
            uniquePokemonsDict[pokemon.id] = pokemon
        }

        // 辞書から配列に変換し、ソート
        pokemons = uniquePokemonsDict.values.sorted(by: { $0.number < $1.number })
    }
}
