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
        pokemonNumber: Int
    ) {
        _router = StateObject(wrappedValue: router)
        self.input = input
        state = .init(pokemonNumber: pokemonNumber)
    }

    public var body: some View {
        RouterView(
            router: router,
            withNavigation: input.withNavigation
        ) {
            content()
                .when(state.shouldShowEmptyView) { _ in
                    emptyView()
                }
                .task {
                    await state.getPokemonDetail()
                }
        }
    }
}

extension PokemonDetailView {

    @ViewBuilder
    private func content() -> some View {
        LazyVStack {
            ForEach(state.sections, id: \.self) { section in
                switch section {
                case .mainVisual:
                    EmptyView()
                case .description:
                    EmptyView()
                case .information:
                    EmptyView()
                }
            }
        }
        .padding(.horizontal, SpaceToken.m)
        .refreshableScrollView(spaceName: "PokemonDetail") {
            await state.refresh()
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackgroundSecondary))
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
                await state.refresh()
            }
        }
    }
}
