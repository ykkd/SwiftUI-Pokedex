//
//  PokemonSwiftDataWrapperTests.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/24.
//

// swiftlint:disable large_tuple

@testable import SwiftDataWrapper
import Entity
import Foundation
import Testing
import TestUtility
private import SwiftData

// MARK: - PokemonSwiftDataWrapperTests
@Suite(.serialized)
actor PokemonSwiftDataWrapperTests {

    init() async throws {
        let wrapper = await PokemonSwiftDataWrapper()
        try await wrapper.reset()
    }
}

// MARK: PokemonSwiftDataWrapperTests.WritePokemonTests
extension PokemonSwiftDataWrapperTests {

    actor WritePokemonTests {
        typealias TestCase = (
            data: FavorablePokemon,
            expectation: FavorablePokemon?,
            loc: SourceLocation
        )

        static let testCases: [TestCase] = [
            (
                data: FavorablePokemon(
                    name: "1",
                    number: 1,
                    imageUrl: nil,
                    subImageUrl: nil,
                    isFavorite: true
                ),
                expectation: FavorablePokemon(
                    name: "1",
                    number: 1,
                    imageUrl: nil,
                    subImageUrl: nil,
                    isFavorite: true
                ),
                loc: .generate()
            ),
            (
                data: FavorablePokemon(
                    name: "1",
                    number: 1,
                    imageUrl: nil,
                    subImageUrl: nil,
                    isFavorite: false
                ),
                expectation: nil,
                loc: .generate()
            ),
        ]

        @Test(arguments: Self.testCases)
        func test(testCase: TestCase) async {
            do {
                let wrapper = await PokemonSwiftDataWrapper()

                try await wrapper.writePokemon(testCase.data)

                let output = try await wrapper.readAllFavoritePokemon()

                let expectedCount = testCase.expectation == nil ? 0 : 1
                #expect(output.count == expectedCount)

                if expectedCount > 0 {
                    #expect(output.first!.name == testCase.expectation!.name)
                    #expect(output.first!.number == testCase.expectation!.number)
                    #expect(output.first!.imageUrl == testCase.expectation!.imageUrl)
                    #expect(output.first!.subImageUrl == testCase.expectation!.subImageUrl)
                    #expect(await output.first!.isFavorite == testCase.expectation!.isFavorite)
                } else {
                    #expect(output.isEmpty)
                }
            } catch {
                Issue.record("unexpected error: \(error)")
            }
        }
    }
}

// MARK: PokemonSwiftDataWrapperTests.ReadAllFavoritePokemonTests
extension PokemonSwiftDataWrapperTests {

    actor ReadAllFavoritePokemonTests {
        typealias TestCase = (
            data: [FavorablePokemon],
            expectation: [FavorablePokemon],
            loc: SourceLocation
        )

        static let testCases: [TestCase] = [
            (
                data: [],
                expectation: [],
                loc: .generate()
            ),
            (
                data: [
                    FavorablePokemon(
                        name: "1",
                        number: 1,
                        imageUrl: nil,
                        subImageUrl: nil,
                        isFavorite: true
                    ),
                ],
                expectation: [
                    FavorablePokemon(
                        name: "1",
                        number: 1,
                        imageUrl: nil,
                        subImageUrl: nil,
                        isFavorite: true
                    ),
                ],
                loc: .generate()
            ),
            (
                data: [
                    FavorablePokemon(
                        name: "1",
                        number: 1,
                        imageUrl: nil,
                        subImageUrl: nil,
                        isFavorite: true
                    ),
                    FavorablePokemon(
                        name: "2",
                        number: 2,
                        imageUrl: nil,
                        subImageUrl: nil,
                        isFavorite: false
                    ),
                ],
                expectation: [
                    FavorablePokemon(
                        name: "1",
                        number: 1,
                        imageUrl: nil,
                        subImageUrl: nil,
                        isFavorite: true
                    ),
                ],
                loc: .generate()
            ),
        ]

        @Test(arguments: Self.testCases)
        func test(testCase: TestCase) async {
            do {
                let wrapper = await PokemonSwiftDataWrapper()

                for pokemon in testCase.data {
                    try await wrapper.writePokemon(pokemon)
                }

                let output = try await wrapper.readAllFavoritePokemon()

                #expect(output.count == testCase.expectation.count)

                await output.enumerated().asyncMap {
                    #expect($0.element.name == testCase.expectation[$0.offset].name)
                    #expect($0.element.number == testCase.expectation[$0.offset].number)
                    #expect($0.element.imageUrl == testCase.expectation[$0.offset].imageUrl)
                    #expect($0.element.subImageUrl == testCase.expectation[$0.offset].subImageUrl)
                    #expect(await $0.element.isFavorite == testCase.expectation[$0.offset].isFavorite)
                }
            } catch {
                Issue.record("unexpected error: \(error)")
            }
        }
    }
}

// MARK: PokemonSwiftDataWrapperTests.ReadFavoritePokemonTests
extension PokemonSwiftDataWrapperTests {

    actor ReadFavoritePokemonTests {
        typealias TestCase = (
            data: [FavorablePokemon],
            number: Int,
            expectation: FavorablePokemon?,
            loc: SourceLocation
        )

        static let testCases: [TestCase] = [
            (
                data: [],
                number: -1,
                expectation: nil,
                loc: .generate()
            ),
            (
                data: [
                    FavorablePokemon(
                        name: "1",
                        number: 1,
                        imageUrl: nil,
                        subImageUrl: nil,
                        isFavorite: true
                    ),
                ],
                number: 1,
                expectation: FavorablePokemon(
                    name: "1",
                    number: 1,
                    imageUrl: nil,
                    subImageUrl: nil,
                    isFavorite: true
                ),
                loc: .generate()
            ),
            (
                data: [
                    FavorablePokemon(
                        name: "1",
                        number: 1,
                        imageUrl: nil,
                        subImageUrl: nil,
                        isFavorite: false
                    ),
                ],
                number: 1,
                expectation: nil,
                loc: .generate()
            ),
            (
                data: [
                    FavorablePokemon(
                        name: "1",
                        number: 1,
                        imageUrl: nil,
                        subImageUrl: nil,
                        isFavorite: true
                    ),
                ],
                number: 2,
                expectation: nil,
                loc: .generate()
            ),
        ]

        @Test(arguments: Self.testCases)
        func test(testCase: TestCase) async {
            do {
                let wrapper = await PokemonSwiftDataWrapper()

                for pokemon in testCase.data {
                    try await wrapper.writePokemon(pokemon)
                }

                let output = try await wrapper.readFavoritePokemon(testCase.number)

                let isOutputNil = output == nil
                let isExpectNil = testCase.expectation == nil

                #expect(isOutputNil == isExpectNil)

                #expect(output?.name == testCase.expectation?.name)
                #expect(output?.number == testCase.expectation?.number)
                #expect(output?.imageUrl == testCase.expectation?.imageUrl)
                #expect(output?.subImageUrl == testCase.expectation?.subImageUrl)
                #expect(await output?.isFavorite == testCase.expectation?.isFavorite)
            } catch {
                Issue.record("unexpected error: \(error)")
            }
        }
    }
}

// swiftlint:enable large_tuple
