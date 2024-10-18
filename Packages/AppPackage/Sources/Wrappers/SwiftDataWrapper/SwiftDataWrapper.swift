//
//  SwiftDataWrapper.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/19.
//

import Entity
import SwiftData
import SwiftUI

// MARK: - SwiftDataWrapper
@SwiftDataActor
public final class SwiftDataWrapper {

    @Environment(\.modelContext) private var context
}

// MARK: - Write
extension SwiftDataWrapper {

    public func writePokemon(
        _ data: FavorablePokemon
    ) async throws(ApplicationError) {
        let data = await PokemonModel(
            number: data.pokemon.number,
            name: data.pokemon.name,
            imageUrl: data.pokemon.imageUrl,
            subImageUrl: data.pokemon.subImageUrl,
            isFavorite: data.isFavorite
        )

        context.insert(data)
        do {
            try context.save()
        } catch {
            throw ApplicationError.database(.write(error))
        }
    }
}

// MARK: - Read
extension SwiftDataWrapper {

    public func readAllPokemon() async throws(ApplicationError) -> [FavorablePokemon] {
        do {
            let models = try context.fetch(FetchDescriptor<PokemonModel>())
            return models.map(convert)
        } catch {
            throw ApplicationError.database(.read(error))
        }
    }

    public func readPokemon(_ number: Int) async throws(ApplicationError) -> FavorablePokemon? {
        do {
            let fetchDescriptor = FetchDescriptor<PokemonModel>(
                predicate: #Predicate { $0.number == number }
            )
            let models = try context.fetch(fetchDescriptor)
            return models.first.map(convert)
        } catch {
            throw ApplicationError.database(.read(error))
        }
    }
}

// MARK: - Private
extension SwiftDataWrapper {

    private func convert(_ model: PokemonModel) -> FavorablePokemon {
        FavorablePokemon(
            pokemon: .init(
                name: model.name,
                number: model.number,
                imageUrl: model.imageUrl,
                subImageUrl: model.subImageUrl
            ),
            isFavorite: model.isFavorite
        )
    }
}
