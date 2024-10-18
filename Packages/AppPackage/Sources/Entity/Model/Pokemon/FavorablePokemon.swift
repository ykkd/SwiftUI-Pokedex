//
//  FavorablePokemon.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/19.
//

import Foundation

public actor FavorablePokemon {

    public let pokemon: Pokemon

    public private(set) var isFavorite: Bool

    public init(pokemon: Pokemon, isFavorite: Bool) {
        self.pokemon = pokemon
        self.isFavorite = isFavorite
    }

    public func updateIsFavorite(_ value: Bool) {
        isFavorite = value
    }
}
