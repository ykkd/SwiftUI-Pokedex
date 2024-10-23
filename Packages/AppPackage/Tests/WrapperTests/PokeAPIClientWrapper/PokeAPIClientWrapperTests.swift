//
//  PokeAPIClientWrapperTests.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/24.
//

// swiftlint:disable large_tuple

@testable import PokeAPIClientWrapper
import Entity
import Foundation
import Testing
import TestUtility

actor PokeAPIClientWrapperTests {

    actor GetPokemonListTests {
        typealias TestCase = (
            limit: Int,
            offset: Int,
            expectation: PokemonAggregate,
            loc: SourceLocation
        )

        static let testCases: [TestCase] = [
            (
                limit: 1,
                offset: 0,
                expectation: PokemonAggregate(
                    totalCount: 1302,
                    pokemons: [
                        .init(name: "bulbasaur", urlString: "https://pokeapi.co/api/v2/pokemon/1/")!,
                    ]
                ),
                loc: .generate()
            ),
            (
                limit: 2,
                offset: 1,
                expectation: PokemonAggregate(
                    totalCount: 1302,
                    pokemons: [
                        .init(name: "ivysaur", urlString: "https://pokeapi.co/api/v2/pokemon/2/")!,
                        .init(name: "venusaur", urlString: "https://pokeapi.co/api/v2/pokemon/3/")!,
                    ]
                ),
                loc: .generate()
            ),
            (
                limit: -1,
                offset: -1,
                expectation: PokemonAggregate(
                    totalCount: 1302,
                    pokemons: []
                ),
                loc: .generate()
            ),
        ]

        @Test(arguments: Self.testCases)
        func test(testCase: TestCase) async {
            do {
                let client = PokeAPIClientWrapper()
                let output = try await client.getPokemonList(limit: testCase.limit, offset: testCase.offset)

                #expect(output.totalCount == testCase.expectation.totalCount)
                #expect(output.pokemons == testCase.expectation.pokemons)
            } catch {
                Issue.record("unexpected error: \(error)")
            }
        }
    }
}

// swiftlint:enable large_tuple
