//
//  PokemonListViewLogic.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/24.
//

// swiftlint:disable large_tuple

@testable import PokemonListScreen
import Entity
import Foundation
import Testing
import TestUtility

enum PokemonListViewLogicTests {

    actor MakeUniqueAndSortedTests {
        typealias TestCase = (
            current: [Pokemon],
            addition: [Pokemon],
            expectation: [Pokemon],
            loc: SourceLocation
        )

        static let testCases: [TestCase] = [
            (
                current: [],
                addition: [],
                expectation: [],
                loc: .generate()
            ),
            (
                current: [
                    .init(name: "2", number: 2, imageUrl: nil, subImageUrl: nil),
                    .init(name: "1", number: 1, imageUrl: nil, subImageUrl: nil),
                    .init(name: "100", number: 100, imageUrl: nil, subImageUrl: nil),
                    .init(name: "10", number: 10, imageUrl: nil, subImageUrl: nil),
                ],
                addition: [],
                expectation: [
                    .init(name: "1", number: 1, imageUrl: nil, subImageUrl: nil),
                    .init(name: "2", number: 2, imageUrl: nil, subImageUrl: nil),
                    .init(name: "10", number: 10, imageUrl: nil, subImageUrl: nil),
                    .init(name: "100", number: 100, imageUrl: nil, subImageUrl: nil),
                ],
                loc: .generate()
            ),
            (
                current: [],
                addition: [
                    .init(name: "2", number: 2, imageUrl: nil, subImageUrl: nil),
                    .init(name: "1", number: 1, imageUrl: nil, subImageUrl: nil),
                    .init(name: "100", number: 100, imageUrl: nil, subImageUrl: nil),
                    .init(name: "10", number: 10, imageUrl: nil, subImageUrl: nil),
                ],
                expectation: [
                    .init(name: "1", number: 1, imageUrl: nil, subImageUrl: nil),
                    .init(name: "2", number: 2, imageUrl: nil, subImageUrl: nil),
                    .init(name: "10", number: 10, imageUrl: nil, subImageUrl: nil),
                    .init(name: "100", number: 100, imageUrl: nil, subImageUrl: nil),
                ],
                loc: .generate()
            ),
            (
                current: [
                    .init(name: "10", number: 10, imageUrl: nil, subImageUrl: nil),
                    .init(name: "1", number: 1, imageUrl: nil, subImageUrl: nil),
                ],
                addition: [
                    .init(name: "100", number: 100, imageUrl: nil, subImageUrl: nil),
                    .init(name: "2", number: 2, imageUrl: nil, subImageUrl: nil),
                ],
                expectation: [
                    .init(name: "1", number: 1, imageUrl: nil, subImageUrl: nil),
                    .init(name: "2", number: 2, imageUrl: nil, subImageUrl: nil),
                    .init(name: "10", number: 10, imageUrl: nil, subImageUrl: nil),
                    .init(name: "100", number: 100, imageUrl: nil, subImageUrl: nil),
                ],
                loc: .generate()
            ),
            (
                current: [
                    .init(name: "1", number: 1, imageUrl: nil, subImageUrl: nil),
                ],
                addition: [
                    .init(name: "1", number: 1, imageUrl: nil, subImageUrl: nil),
                ],
                expectation: [
                    .init(name: "1", number: 1, imageUrl: nil, subImageUrl: nil),
                ],
                loc: .generate()
            ),
        ]

        @Test(arguments: Self.testCases)
        func test(testCase: TestCase) {
            let output = PokemonListViewLogic.makeUniqueAndSorted(current: testCase.current, addition: testCase.addition)

            #expect(output == testCase.expectation)
        }
    }
}

// swiftlint:enable large_tuple
