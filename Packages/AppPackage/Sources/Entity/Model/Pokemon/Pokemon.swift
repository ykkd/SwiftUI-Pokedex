//
//  Pokemon.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/14.
//

import Foundation

public struct Pokemon: Sendable, Hashable {

    public let name: String

    public let number: Int

    public let imageUrl: URL

    public init?(
        name: String,
        urlString: String
    ) {
        guard let number = PokemonNumberGenerator.generate(from: urlString),
              let imageUrl = PokemonImageURLGenerator.generateThumbnailURL(from: number) else {
            return nil
        }
        self.name = name
        self.number = number
        self.imageUrl = imageUrl
    }
}
