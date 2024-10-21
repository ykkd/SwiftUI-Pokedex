//
//  FavoritePokemonListViewContainer.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/19.
//

import Dependencies
import Entity
import RouterCore
import SwiftUI

// MARK: - FavoritePokemonListViewContainer
public struct FavoritePokemonListViewContainer: Sendable {

    public var view: @MainActor @Sendable (
        _ router: BaseRouter,
        _ input: CommonScreenInput
    ) -> AnyView

    public init(
        view: @escaping @MainActor @Sendable (
            _ router: BaseRouter,
            _ input: CommonScreenInput
        ) -> AnyView
    ) {
        self.view = view
    }
}

// MARK: TestDependencyKey
extension FavoritePokemonListViewContainer: TestDependencyKey {

    public static var testValue: Self {
        .init(view: unimplemented("", placeholder: AnyView(Text("TestValue of FavoritePokemonListView"))))
    }
}

extension DependencyValues {

    public var favoritePokemonListViewContainer: FavoritePokemonListViewContainer {
        get { self[FavoritePokemonListViewContainer.self] }
        set { self[FavoritePokemonListViewContainer.self] = newValue }
    }
}
