//
//  PokemonDetailViewLogicTests.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/23.
//

// swiftlint:disable large_tuple line_length

@testable import PokemonDetailScreen
import Entity
import Foundation
import SFSafeSymbols
import Testing
import TestUtility

enum PokemonDetailViewLogicTests {

    actor GetSymbolForStatusImageTests {
        typealias TestCase = (input: PokemonStatus, expectation: SFSymbol, loc: SourceLocation)

        static let testCases: [TestCase] = [
            (
                input: PokemonStatus(name: "attack", value: 1)!,
                expectation: .flameFill,
                loc: .generate()
            ),
        ]

        @Test(arguments: Self.testCases)
        func test(testCase: TestCase) {
            #expect(PokemonDetailViewLogic.getSymbolForStatusImage(testCase.input).rawValue == testCase.expectation.rawValue)
        }
    }

    actor GenerateFavorablePokemonTests {
        typealias TestCase = (data: PokemonDetail?, isFavorite: Bool, expectation: FavorablePokemon?, loc: SourceLocation)

        static let testCases: [TestCase] = [
            (
                data: nil,
                isFavorite: true,
                expectation: nil,
                loc: .generate()
            ),
            (
                data: nil,
                isFavorite: false,
                expectation: nil,
                loc: .generate()
            ),
            (
                data: .mock,
                isFavorite: true,
                expectation: .mock(data: .mock, isFavorite: true),
                loc: .generate()
            ),
            (
                data: .mock,
                isFavorite: false,
                expectation: .mock(data: .mock, isFavorite: false),
                loc: .generate()
            ),
        ]

        @Test(arguments: Self.testCases)
        func test(testCase: TestCase) async {
            let output = PokemonDetailViewLogic.generateFavorablePokemon(testCase.data, isFavorite: testCase.isFavorite)
            #expect(output?.name == testCase.expectation?.name)
            #expect(output?.number == testCase.expectation?.number)
            #expect(output?.imageUrl == testCase.expectation?.imageUrl)
            #expect(output?.subImageUrl == testCase.expectation?.subImageUrl)
            #expect(await output?.isFavorite == testCase.expectation?.isFavorite)
        }
    }

    actor GenerateInformationItemViewInputTests {
        typealias TestCase = (type: PokemonDetail.Information.InfoType, expectation: InformationItemViewInput, loc: SourceLocation)

        static let testCases: [TestCase] = [
            (
                type: .pokemonTypes([]),
                expectation: .init(
                    symbol: .dropHalffull,
                    title: "Type",
                    description: ""
                ),
                loc: .generate()
            ),
            (
                type: .pokemonTypes([.bug]),
                expectation: .init(
                    symbol: .dropHalffull,
                    title: "Type",
                    description: "\(PokemonType.bug.rawValue.initialLetterUppercased())"
                ),
                loc: .generate()
            ),
            (
                type: .pokemonTypes([.bug, .dark]),
                expectation: .init(
                    symbol: .dropHalffull,
                    title: "Type",
                    description: "\(String(describing: PokemonType.bug.rawValue.initialLetterUppercased())) \(String(describing: PokemonType.dark.rawValue.initialLetterUppercased()))"
                ),
                loc: .generate()
            ),
            (
                type: .height(10.0),
                expectation: .init(
                    symbol: .personFill,
                    title: "Height",
                    description: "10.0m"
                ),
                loc: .generate()
            ),
            (
                type: .weight(10.0),
                expectation: .init(
                    symbol: .scalemassFill,
                    title: "Weight",
                    description: "10.0kg"
                ),
                loc: .generate()
            ),
            (
                type: .firstAbility("Test"),
                expectation: .init(
                    symbol: .circleLefthalfFilled,
                    title: "Ability 1",
                    description: "Test"
                ),
                loc: .generate()
            ),
            (
                type: .secondAbility("Test"),
                expectation: .init(
                    symbol: .circleRighthalfFilled,
                    title: "Ability 2",
                    description: "Test"
                ),
                loc: .generate()
            ),
            (
                type: .hiddenAblity("Test"),
                expectation: .init(
                    symbol: .circleInsetFilled,
                    title: "Hidden Ability",
                    description: "Test"
                ),
                loc: .generate()
            ),
            (
                type: .hiddenAblity(nil),
                expectation: .init(
                    symbol: .circleInsetFilled,
                    title: "Hidden Ability",
                    description: "None"
                ),
                loc: .generate()
            ),
        ]

        @Test(arguments: Self.testCases)
        func test(testCase: TestCase) {
            let output = PokemonDetailViewLogic.generateInformationItemViewInput(testCase.type)
            #expect(output.symbol.rawValue == testCase.expectation.symbol.rawValue)
            #expect(output.title == testCase.expectation.title)
            #expect(output.description == testCase.expectation.description)
        }
    }
}

// swiftlint:enable large_tuple line_length
