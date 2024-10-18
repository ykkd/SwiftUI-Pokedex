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

@MainActor
@Observable
final class PokemonListViewState {

    @ObservationIgnored
    @Dependency(\.getPokemonListUseCase) private var getPokemonListUseCase

    private(set) var totalCount: Int = .zero

    private(set) var pokemons: [Pokemon] = []

    init() {}

    func getData(_ limit: Int, offset: Int) async {
        do {
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
