//
//  PokeAPIClientWrapper.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/14.
//

import Foundation
import OpenAPIRuntime
private import OpenAPIURLSession
import Entity

// MARK: - PokeAPIClientWrapperProtocol
public protocol PokeAPIClientWrapperProtocol {
    func getPokemonList(limit: Int, offset: Int) async throws -> PokemonAggregate
}

// MARK: - PokeAPIClientWrapper
public struct PokeAPIClientWrapper: PokeAPIClientWrapperProtocol {

    private let client: Client

    public init() throws {
        client = try Client(
            serverURL: Servers.server1(),
            transport: URLSessionTransport()
        )
    }
}

// MARK: - PokemonList
extension PokeAPIClientWrapper {

    public func getPokemonList(limit: Int, offset: Int) async throws -> PokemonAggregate {
        do {
            let response = try await client.pokemon_list(query: .init(limit: 0, offset: 0, q: ""))
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
