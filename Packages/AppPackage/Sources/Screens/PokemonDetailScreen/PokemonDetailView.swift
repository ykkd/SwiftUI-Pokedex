//
//  PokemonDetailView.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/17.
//

private import Dependencies
private import DependencyContainer
import Entity
import Router
import SwiftUI
private import DesignSystem
private import SFSafeSymbols
private import ScreenExtension

// MARK: - PokemonDetailView
public struct PokemonDetailView: View {

    @StateObject private var router: Router

    @State private var state: PokemonDetailViewState

    private let input: CommonScreenInput

    public init(
        router: Router,
        input: CommonScreenInput,
        pokemon: Pokemon
    ) {
        _router = StateObject(wrappedValue: router)
        self.input = input
        state = .init(pokemon: pokemon)
    }

    public var body: some View {
        RouterView(
            router: router,
            withNavigation: input.withNavigation
        ) {
            content()
                .when(true) { _ in
                    emptyView()
                }
        }
    }
}

extension PokemonDetailView {

    private func content() -> some View {
        EmptyView()
    }
}

extension PokemonDetailView {

    private func emptyView() -> some View {
        GeometryReader { geometry in
            CenteringView {
                ProgressView()
                    .frame(width: 64, height: 64)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .refreshableScrollView(spaceName: "PokemonDetailEmptyState") {
                // TODO: implement
            }
        }
    }
}
