//
//  PokemonType.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/17.
//

import Foundation
import SharedExtension

public enum PokemonType: String, Sendable, Hashable {
    case normal
    case fighting
    case flying
    case poison
    case ground
    case rock
    case bug
    case ghost
    case steel
    case fire
    case water
    case grass
    case electric
    case psychic
    case ice
    case dragon
    case dark
    case fairy
    case unknown
    case shadow

    public init?(_ pokemonType: String) {
        if let type = PokemonType(rawValue: pokemonType) {
            self = type
        } else {
            return nil
        }
    }

    public var text: String {
        rawValue.initialLetterUppercased()
    }

    public var hex: String {
        switch self {
        case .normal:
            "A0A0A0"
        case .fighting:
            "E85157"
        case .flying:
            "5496EE"
        case .poison:
            "9B62C0"
        case .ground:
            "BD9B31"
        case .rock:
            "F7BF1D"
        case .bug:
            "45C648"
        case .ghost:
            "6258A7"
        case .steel:
            "707794"
        case .fire:
            "FE9854"
        case .water:
            "55BAF6"
        case .grass:
            "8BBD0B"
        case .electric:
            "E3CF0A"
        case .psychic:
            "E462F1"
        case .ice:
            "54E6F3"
        case .dragon:
            "FC7447"
        case .dark:
            "556CCB"
        case .fairy:
            "F85F89"
        case .unknown:
            "282828"
        case .shadow:
            "2A373E"
        }
    }
}
