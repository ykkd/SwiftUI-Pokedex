//
//  PokemonListViewLogic.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/24.
//

import Entity
import Foundation

enum PokemonListViewLogic {

    static func makeUniqueAndSorted(
        current: [Pokemon],
        addition: [Pokemon]
    ) -> [Pokemon] {
        var uniquePokemonsDict = Dictionary(uniqueKeysWithValues: current.map { ($0.id, $0) }) // idをキーにしてユニークな辞書を作成

        for pokemon in addition {
            uniquePokemonsDict[pokemon.id] = pokemon
        }

        return uniquePokemonsDict.values.sorted(by: { $0.number < $1.number })
    }
}
