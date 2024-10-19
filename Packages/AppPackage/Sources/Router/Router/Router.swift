//
//  Router.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/14.
//

import Dependencies
import DependencyContainer
import Entity
import RouterCore
import SwiftUI

// MARK: - Router
public final class Router: BaseRouter {

    @Dependency(\.rootViewContainer) private var rootViewContainer
    @Dependency(\.pokemonListViewContainer) private var pokemonListViewContainer
    @Dependency(\.pokemonDetailViewContainer) private var pokemonDetailViewContainer
    @Dependency(\.favoritePokemonListViewContainer) private var favoritePokemonListViewContainer

    override public func view(
        _ screen: Screen,
        transition: ScreenTransition
    ) -> AnyView {
        AnyView(buildView(screen: screen, transition: transition))
    }
}

extension Router {

    @ViewBuilder
    private func buildView(
        screen: Screen,
        transition: ScreenTransition
    ) -> some View {
        switch screen {
        case .root:
            rootViewContainer.view(
                router(transition: transition),
                CommonScreenInput(
                    withNavigation: transition.withNavigation,
                    naviBarLeadingButtonType: transition.naviBarLeadingButtonType
                )
            )
        case .pokemonList:
            pokemonListViewContainer.view(
                router(transition: transition),
                CommonScreenInput(
                    withNavigation: transition.withNavigation,
                    naviBarLeadingButtonType: transition.naviBarLeadingButtonType
                )
            )
        case let .pokemonDetail(number):
            pokemonDetailViewContainer.view(
                router(transition: transition),
                CommonScreenInput(
                    withNavigation: transition.withNavigation,
                    naviBarLeadingButtonType: transition.naviBarLeadingButtonType
                ),
                number
            )
        case .favoritePokemonList:
            favoritePokemonListViewContainer.view(
                router(transition: transition),
                CommonScreenInput(
                    withNavigation: transition.withNavigation,
                    naviBarLeadingButtonType: transition.naviBarLeadingButtonType
                )
            )
        }
    }

    private func router(transition: ScreenTransition) -> Router {
        switch transition {
        case .push,
             .alert:
            self
        case .sheet:
            Router(isPresented: presentingSheet)
        case .fullScreen:
            Router(isPresented: presentingFullScreen)
        }
    }
}

extension Router {

    public func buildTabView(_ tab: RootTab) -> some View {
        switch tab {
        case .pokemonList:
            pokemonListViewContainer.view(
                Router(isPresented: .init(.constant(.pokemonList))),
                CommonScreenInput(
                    withNavigation: true,
                    naviBarLeadingButtonType: nil
                )
            )
        case .favoritePokemonList:
            favoritePokemonListViewContainer.view(
                Router(isPresented: .init(.constant(.favoritePokemonList))),
                CommonScreenInput(
                    withNavigation: true,
                    naviBarLeadingButtonType: nil
                )
            )
        }
    }
}
