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

    private(set) var imageIds: [URL: UUID] = [:]

    var shouldShowBottomProgress: Bool {
        guard totalCount != .zero else {
            return false
        }
        return pokemons.count == totalCount || !isLoading
    }

    private var limitForRefresh: Int {
        if pokemons.count != .zero {
            pokemons.count
        } else {
            limitPerPage
        }
    }

    init() {}

    func getInitialData() async {
        await getData(limitPerPage, offset: .zero)
    }

    func refresh() async {
        for url in imageIds.keys {
            imageIds[url] = .init()
        }
//        await getInitialData()
    }

    func getNextPageIfNeeded(last pokemon: Pokemon) async {
        guard pokemons.last == pokemon,
              totalCount != pokemons.count else {
            return
        }
        await getData(limitPerPage, offset: pokemon.number + 1)
    }

    func getImageId(for imageUrl: URL) -> UUID {
        if imageIds[imageUrl] == nil {
            let id = UUID()
            imageIds[imageUrl] = id
        }
        return imageIds[imageUrl]!
    }
}

extension PokemonListViewState {

    private func getData(_ limit: Int, offset: Int) async {
        defer { isLoading = false }
        do {
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
        } catch {
            // TODO: implement
        }
    }
}
