//
//  PokemonSwiftDataWrapper.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/19.
//

import Entity
import SwiftData
import SwiftUI

// MARK: - PokemonSwiftDataWrapper
@SwiftDataActor
public final class PokemonSwiftDataWrapper: Sendable {

    private let container: ModelContainer

    public init(useInMemoryStore: Bool = false) {
        do {
            let config = ModelConfiguration(for: PokemonModel.self, isStoredInMemoryOnly: useInMemoryStore)
            container = try ModelContainer(for: PokemonModel.self, configurations: config)
        } catch {
            fatalError("ModelContainer initialization failed")
        }
    }
}

// MARK: - Write
extension PokemonSwiftDataWrapper {

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

        let context = ModelContext(container)
        context.insert(data)
        do {
            try context.save()
        } catch {
            throw ApplicationError.database(.write(error))
        }
    }
}

// MARK: - Read
extension PokemonSwiftDataWrapper {

    public func readAllPokemon() async throws(ApplicationError) -> [FavorablePokemon] {
        do {
            let context = ModelContext(container)
            let models = try context.fetch(FetchDescriptor<PokemonModel>(sortBy: [SortDescriptor(\.number)]))
            return models.map(convert)
        } catch {
            throw ApplicationError.database(.read(error))
        }
    }

    public func readPokemon(_ number: Int) async throws(ApplicationError) -> FavorablePokemon? {
        do {
            let context = ModelContext(container)
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
extension PokemonSwiftDataWrapper {

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
