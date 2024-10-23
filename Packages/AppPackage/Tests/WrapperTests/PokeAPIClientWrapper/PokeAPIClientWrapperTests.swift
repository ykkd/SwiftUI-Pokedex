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
            (
                limit: 100_000,
                offset: 100_000,
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

    actor GetPokemonDetailSuccessTests {
        typealias TestCase = (
            number: Int,
            expectation: PokemonDetail,
            loc: SourceLocation
        )

        static let testCases: [TestCase] = [
            (
                number: 1,
                expectation: PokemonDetail(
                    number: 1,
                    name: "bulbasaur",
                    typeHex: "8BBD0B",
                    information: .init(
                        infoTypes: [
                            .pokemonTypes([.grass, .poison]),
                            .height(0.7),
                            .weight(6.9),
                            .firstAbility("Overgrow"),
                            .secondAbility(nil),
                            .hiddenAblity("Chlorophyll"),
                        ]
                    ),
                    status: [
                        PokemonStatus(name: "hp", value: 45)!,
                        PokemonStatus(name: "attack", value: 49)!,
                        PokemonStatus(name: "defense", value: 49)!,
                        PokemonStatus(name: "special-attack", value: 65)!,
                        PokemonStatus(name: "special-defense", value: 65)!,
                        PokemonStatus(name: "speed", value: 45)!,
                    ]
                ),
                loc: .generate()
            ),
        ]

        @Test(arguments: Self.testCases)
        func test(testCase: TestCase) async {
            do {
                let client = PokeAPIClientWrapper()
                let output = try await client.getPokemonDetail(testCase.number)

                #expect(output.number == testCase.expectation.number)
                #expect(output.name == testCase.expectation.name)
                #expect(output.imageUrl == testCase.expectation.imageUrl)
                #expect(output.subImageUrl == testCase.expectation.subImageUrl)
                #expect(output.typeHex == testCase.expectation.typeHex)
                #expect(output.information == testCase.expectation.information)
                #expect(output.status == testCase.expectation.status)
            } catch {
                Issue.record("unexpected error: \(error)")
            }
        }
    }

    actor GetPokemonDetailFailureTests {
        typealias TestCase = (
            number: Int,
            expectation: ApplicationError,
            loc: SourceLocation
        )

        static let testCases: [TestCase] = [
            (
                number: -1,
                expectation: ApplicationError.network(
                    .api(
                        NSErrorGenerator.generate(domain: "test", code: 404)
                    )
                ),
                loc: .generate()
            ),
        ]

        @Test(arguments: Self.testCases)
        func test(testCase: TestCase) async {
            do {
                let client = PokeAPIClientWrapper()
                let output = try await client.getPokemonDetail(testCase.number)
                Issue.record("unexpected response: \(output)")

            } catch {
                let nsError = error as NSError
                let expectedNsError = testCase.expectation as NSError
                #expect(nsError.code == expectedNsError.code)
            }
        }
    }
}

// swiftlint:enable large_tuple
