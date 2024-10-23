//
//  PokemonDetailViewLogicTests.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/23.
//

@testable import PokemonDetailScreen
import Entity
import Foundation
import SFSafeSymbols
import Testing
import TestUtility

actor PokemonDetailViewLogicTests {

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
}
