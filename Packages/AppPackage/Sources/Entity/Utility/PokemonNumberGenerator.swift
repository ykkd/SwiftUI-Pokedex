//
//  PokemonNumberGenerator.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/14.
//

import Foundation

enum PokemonNumberGenerator {

    static func generate(from url: String) -> Int? {
        guard !url.isEmpty,
              let number = generate(fromPokemon: url) else {
            return nil
        }
        return number
    }

    private static func generate(fromPokemon url: String) -> Int? {
        var removePrefix = url.replacingOccurrences(of: "https://pokeapi.co/api/v2/pokemon/", with: "")
        removePrefix.removeLast()
        return Int(removePrefix)
    }
}
