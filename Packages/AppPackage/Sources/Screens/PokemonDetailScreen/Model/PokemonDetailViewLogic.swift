//
//  PokemonDetailViewLogic.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/21.
//

import Entity
import Foundation
import SFSafeSymbols

typealias ViewLogic = PokemonDetailViewLogic

// MARK: - PokemonDetailViewLogic
enum PokemonDetailViewLogic {

    static func getSymbolForStatusImage(_ status: PokemonStatus) -> SFSymbol {
        switch status.type {
        case .attack:
            .flameFill
        case .defense:
            .shieldFill
        case .hp:
            .heartFill
        case .specialAttack:
            .firewallFill
        case .specialDefense:
            .boltShield
        case .speed:
            .figureRun
        }
    }

    static func generateFavorablePokemon(_ data: PokemonDetail?, isFavorite: Bool) -> FavorablePokemon? {
        if let data {
            .init(
                name: data.name,
                number: data.number,
                imageUrl: data.imageUrl,
                subImageUrl: data.subImageUrl,
                isFavorite: isFavorite
            )
        } else {
            nil
        }
    }

    static func generateInformationItemViewInput(_ type: PokemonDetail.Information.InfoType) -> InformationItemViewInput {
        let symbol: SFSymbol
        let title: String
        let description: String

        switch type {
        case let .pokemonTypes(pokemonTypes):
            symbol = .dropHalffull
            title = "Type"
            let joined = pokemonTypes.map(\.text).joined(separator: " ")
            description = joined
        case let .height(height):
            symbol = .personFill
            title = "Height"
            description = "\(height)m"
        case let .weight(weight):
            symbol = .scalemassFill
            title = "Weight"
            description = "\(weight)kg"
        case let .firstAbility(ability):
            symbol = .circleLefthalfFilled
            title = "Ability 1"
            description = "\(ability)"
        case let .secondAbility(ability):
            symbol = .circleRighthalfFilled
            title = "Ability 2"
            description = "\(ability ?? "None")"
        case let .hiddenAblity(ability):
            symbol = .circleInsetFilled
            title = "Hidden Ablity"
            description = "\(ability ?? "None")"
        }

        return .init(
            symbol: symbol,
            title: title,
            description: description
        )
    }
}
