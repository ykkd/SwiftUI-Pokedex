//
//  Pokemon.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/14.
//

import Foundation

public struct Pokemon: Sendable, Hashable, Identifiable, Equatable {

    public var id: Int {
        number
    }

    public let name: String

    public let number: Int

    public let imageUrl: URL?

    public let subImageUrl: URL?

    public init(
        name: String,
        number: Int,
        imageUrl: URL?,
        subImageUrl: URL?
    ) {
        self.name = name
        self.number = number
        self.imageUrl = imageUrl
        self.subImageUrl = subImageUrl
    }

    public init?(
        name: String,
        urlString: String
    ) {
        guard let number = PokemonNumberGenerator.generate(from: urlString) else {
            return nil
        }
        self.name = name
        self.number = number
        imageUrl = PokemonImageURLGenerator.generateImageURL(from: number)
        subImageUrl = PokemonImageURLGenerator.generateSubImageURL(from: number)
    }
}
