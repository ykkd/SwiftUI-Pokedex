//
//  PokemonModel.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/19.
//

import Foundation
private import SwiftData

@Model
final class PokemonModel {
    var number: Int

    var name: String

    var imageUrl: URL?

    var subImageUrl: URL?

    var isFavorite: Bool

    init(
        number: Int,
        name: String,
        imageUrl: URL?,
        subImageUrl: URL?,
        isFavorite: Bool
    ) {
        self.number = number
        self.name = name
        self.imageUrl = imageUrl
        self.subImageUrl = subImageUrl
        self.isFavorite = isFavorite
    }
}