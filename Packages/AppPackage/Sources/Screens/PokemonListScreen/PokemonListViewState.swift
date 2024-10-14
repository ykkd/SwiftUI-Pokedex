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

    private(set) var pokemons: Set<Pokemon> = []

    init() {}

    func getData(_ limit: Int, offset: Int) async {
        do {
            let data = try await getPokemonListUseCase.execute(limit, offset: offset)
            totalCount = data.totalCount
            let newPokemons: Set<Pokemon> = Set(pokemons.union(data.pokemons))
            let sorted = newPokemons.sorted(by: { $0.number < $1.number })
            pokemons = Set(sorted)
        } catch {
            // TODO: implement
        }
    }
}
