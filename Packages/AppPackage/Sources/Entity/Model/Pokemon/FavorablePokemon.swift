//
//  FavorablePokemon.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/19.
//

import Foundation

// MARK: - FavorablePokemon
public struct FavorablePokemon: Identifiable, Sendable {

    public var id: Int {
        number
    }

    public let name: String

    public let number: Int

    public let imageUrl: URL?

    public let subImageUrl: URL?

    public let isFavoriteContainer: AsyncLockedValue<Bool>

    public var isFavorite: Bool {
        get async {
            await isFavoriteContainer.get()
        }
    }

    public init(
        name: String,
        number: Int,
        imageUrl: URL?,
        subImageUrl: URL?,
        isFavorite: Bool
    ) {
        self.name = name
        self.number = number
        self.imageUrl = imageUrl
        self.subImageUrl = subImageUrl
        isFavoriteContainer = .init(initialValue: isFavorite)
    }

    public func updateIsFavorite(_ value: Bool) async {
        await isFavoriteContainer.set(value)
    }
}

#if DEBUG
extension FavorablePokemon {

    public static func mock(data: PokemonDetail, isFavorite: Bool) -> Self {
        .init(
            name: data.name,
            number: data.number,
            imageUrl: data.imageUrl,
            subImageUrl: data.subImageUrl,
            isFavorite: isFavorite
        )
    }
}
#endif
