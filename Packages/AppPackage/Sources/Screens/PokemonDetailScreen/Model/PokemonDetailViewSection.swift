//
//  PokemonDetailViewSection.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/18.
//

import SwiftUI

enum PokemonDetailViewSection: Identifiable, Hashable {
    case mainVisual
    case description
    case information

    var id: UUID {
        .init()
    }
}
