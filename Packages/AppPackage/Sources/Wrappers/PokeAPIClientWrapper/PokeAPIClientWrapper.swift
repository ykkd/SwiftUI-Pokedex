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
