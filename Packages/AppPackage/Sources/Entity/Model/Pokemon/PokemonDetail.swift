//
//  PokemonDetail.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/17.
//

import Foundation

// MARK: - PokemonDetail
public struct PokemonDetail {

    public let number: Int

    public let name: String

    public let imageUrl: URL?

    public let subImageUrl: URL?

    public let typeHex: String

    public let information: Information

    public let status: [PokemonStatus]

    public init(
        number: Int,
        name: String,
        typeHex: String,
        information: Information,
        status: [PokemonStatus]
    ) {
        self.number = number
        self.name = name
        imageUrl = PokemonImageURLGenerator.generateImageURL(from: number)
        subImageUrl = PokemonImageURLGenerator.generateSubImageURL(from: number)
        self.typeHex = typeHex
        self.information = information
        self.status = status
    }
}

// MARK: PokemonDetail.Information
extension PokemonDetail {

    public struct Information {

        public let types: [Type]

        public init(types: [Type]) {
            self.types = types
        }
    }
}

// MARK: - PokemonDetail.Information.`Type`
extension PokemonDetail.Information {

    public enum `Type` {
        case pokemonTypes([PokemonType])
        case height(Float)
        case weight(Float)
        case firstAbility(String)
        case secondAbility(String?)
        case hiddenAbblity(String?)
    }
}
