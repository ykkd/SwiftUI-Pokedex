//
//  RootTab.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/15.
//

import Foundation

public enum RootTab: Int, CaseIterable {
    case pokemonList = 0

    public var navigationTitle: String {
        switch self {
        case .pokemonList:
            "Pokedex"
        }
    }
}
