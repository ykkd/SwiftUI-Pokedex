//
//  PokemonSwiftDataWrapperContainer.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/19.
//

import Dependencies
import Foundation
import SwiftUI

// MARK: - PokemonSwiftDataWrapperContainer
public struct PokemonSwiftDataWrapperContainer: Sendable {

    public var container: @Sendable () async -> PokemonSwiftDataWrapper

    public init(
        container: @escaping @Sendable () async -> PokemonSwiftDataWrapper
    ) {
        self.container = container
    }
}

// MARK: DependencyKey
extension PokemonSwiftDataWrapperContainer: DependencyKey {

    public static var liveValue: Self {
        .init {
            await PokemonSwiftDataWrapper()
        }
    }
}

extension DependencyValues {

    public var pokemonSwiftDataWrapperContainer: PokemonSwiftDataWrapperContainer {
        get { self[PokemonSwiftDataWrapperContainer.self] }
        set { self[PokemonSwiftDataWrapperContainer.self] = newValue }
    }
}
