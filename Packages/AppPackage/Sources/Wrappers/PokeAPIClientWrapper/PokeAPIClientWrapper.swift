//
//  PokeAPIClientWrapper.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/14.
//

import Foundation
import OpenAPIRuntime
private import OpenAPIURLSession
import Dependencies
import Entity
private import SharedExtension

// MARK: - PokeAPIClientWrapper
public struct PokeAPIClientWrapper: Sendable {

    private let client: any APIProtocol

    public init() {
        do {
            client = try Client(
                serverURL: Servers.server1(),
                transport: URLSessionTransport()
            )
        } catch {
            fatalError("server url is invalid")
        }
    }
}

// MARK: DependencyKey
extension PokeAPIClientWrapper: DependencyKey {

    public static var liveValue: Self {
        PokeAPIClientWrapper()
    }
}

extension DependencyValues {

    public var pokeAPIClientWrapper: PokeAPIClientWrapper {
        get { self[PokeAPIClientWrapper.self] }
        set { self[PokeAPIClientWrapper.self] = newValue }
    }
}

// MARK: - PokemonList
extension PokeAPIClientWrapper {

    public func getPokemonList(limit: Int, offset: Int) async throws(ApplicationError) -> PokemonAggregate {
        do {
            let response = try await client.pokemon_list(query: .init(limit: limit, offset: offset, q: ""))
            let json = try response.ok.body.json

            guard let totalCount = json.count,
                  let results = json.results else {
                throw ApplicationError.network(.invalidResponse)
            }

            let pokemons = try results.compactMap { result in
                if let pokemon = Pokemon(name: result.name, urlString: result.url) {
                    return pokemon
                } else {
                    throw ApplicationError.network(.invalidResponse)
                }
            }

            return PokemonAggregate(totalCount: totalCount, pokemons: pokemons)
        } catch let error as ApplicationError {
            throw error
        } catch {
            throw ApplicationError.network(.api(error))
        }
    }
}

// MARK: - PokemonDetail
extension PokeAPIClientWrapper {

    public func getPokemonDetail(_ number: Int) async throws(ApplicationError) -> PokemonDetail {
        do {
            let response = try await client.pokemon_retrieve(.init(path: .init(id: "\(number)")))
            let json = try response.ok.body.json

            let pokemonDetail = try PokemonDetail(
                number: json.id,
                name: json.name,
                typeHex: generateTypeHex(json),
                information: generateInformation(json),
                status: generateStatus(json)
            )

            return pokemonDetail
        } catch let error as ApplicationError {
            throw error
        } catch {
            throw ApplicationError.network(.api(error))
        }
    }

    private func generateTypeHex(
        _ json: Components.Schemas.PokemonDetail
    ) throws(ApplicationError) -> String {
        let pokemonTypes: [PokemonType] = json.types.sorted { $0.slot < $1.slot }.compactMap { PokemonType($0._type.name) }
        return pokemonTypes.first!.hex
    }

    private func generateInformation(
        _ json: Components.Schemas.PokemonDetail
    ) throws(ApplicationError) -> PokemonDetail.Information {
        guard let height = json.height,
              let weight = json.weight else {
            throw ApplicationError.network(.invalidResponse)
        }
        var types: [PokemonDetail.Information.InfoType] = []

        let pokemonTypes: [PokemonType] = json.types.sorted { $0.slot < $1.slot }.compactMap { PokemonType($0._type.name) }
        types.append(.pokemonTypes(pokemonTypes))

        let mHeight = Float(height) / 10
        types.append(.height(mHeight))

        let kgWeight = Float(weight) / 10
        types.append(.weight(kgWeight))

        var normalAbilities = json.abilities.filter { $0.is_hidden == false }
        normalAbilities.sort { $0.slot < $1.slot }

        if normalAbilities.count == 1 {
            types.append(.firstAbility(normalAbilities[0].ability.name.initialLetterUppercased()))
            types.append(.secondAbility(nil))
        } else if normalAbilities.count > 1 {
            types.append(.firstAbility(normalAbilities[0].ability.name.initialLetterUppercased()))
            types.append(.secondAbility(normalAbilities[1].ability.name.initialLetterUppercased()))
        }

        if let hiddenAbility = json.abilities.first(where: { $0.is_hidden == true }) {
            types.append(.hiddenAbblity(hiddenAbility.ability.name.initialLetterUppercased()))
        } else {
            types.append(.hiddenAbblity(nil))
        }

        return .init(types: types)
    }

    private func generateStatus(
        _ json: Components.Schemas.PokemonDetail
    ) -> [PokemonStatus] {
        json.stats.compactMap { PokemonStatus(name: $0.stat.name, value: $0.base_stat) }.sorted { $0.type.priority < $1.type.priority }
    }
}
