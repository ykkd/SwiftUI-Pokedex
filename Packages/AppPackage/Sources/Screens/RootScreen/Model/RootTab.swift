//
//  RootTab.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/15.
//

import Foundation

enum RootTab: Int {
    case pokemonList = 0

    var navigationTitle: String {
        switch self {
        case .pokemonList:
            "Pokedex"
        }
    }
}
