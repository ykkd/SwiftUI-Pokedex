//
//  PokemonListView.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/15.
//

private import Dependencies
private import DependencyContainer
import Entity
import Router
import SwiftUI
private import DesignSystem
private import SFSafeSymbols
private import ScreenExtension

// MARK: - PokemonListView
public struct PokemonListView: View {

    @StateObject private var router: Router

    @State private var state: PokemonListViewState = .init()

    private let input: CommonScreenInput

    private let trigger: TabDoubleTapTrigger?

    public init(
        router: Router,
        input: CommonScreenInput,
        trigger: TabDoubleTapTrigger?
    ) {
        _router = StateObject(wrappedValue: router)
        self.input = input
        self.trigger = trigger
    }

    public var body: some View {
        RouterView(
            router: router,
            withNavigation: input.withNavigation
        ) {
            content()
                .when(state.pokemons.isEmpty) { _ in
                    emptyView()
                }
                .task {
                    try? await Task.sleep(for: .seconds(2.0))
                    await state.getInitialData()
                }
                .refreshable {
                    await state.refresh()
                }
        }
    }
}

extension PokemonListView {

    @ViewBuilder
    private func content() -> some View {
        let item = GridItem(spacing: SpaceToken.s)
        let itemCount = 3
        let columns: [GridItem] = Array(repeating: item, count: itemCount)

        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                LazyVGrid(columns: columns, spacing: SpaceToken.s) {
                    ForEach(state.pokemons) { pokemon in
                        itemView(pokemon)
                            .task {
                                await state.getNextPageIfNeeded(last: pokemon)
                            }
                    }
                }
                .overlay(alignment: .bottom) {
                    ProgressView()
                        .frame(height: 60)
                        .hidden(state.shouldShowBottomProgress)
                }
                .id("id")
                .padding(.horizontal, SpaceToken.m)
            }
            .onTrigger(of: trigger) {
                withAnimation {
                    proxy.scrollTo("id", anchor: .top)
                }
            }
            .navigationTitle(RootTab.pokemonList.navigationTitle)
            .background(Color(.systemBackgroundSecondary))
        }
    }

    private func itemView(_ pokemon: Pokemon) -> some View {
        Button {
            // TODO: implement
        } label: {
            VStack(spacing: SpaceToken.s) {
                pokemonImage(pokemon)
                Divider()
                pokemonInformation(pokemon)
            }
        }
        .padding(SpaceToken.s)
        .aspectRatio(AspectToken.square.value, contentMode: .fit)
        .background(Color(.systemBackground))
        .cornerRadius(RadiusToken.l)
    }

    private func pokemonImage(_ pokemon: Pokemon) -> some View {
        FallbackableAsyncImage(
            pokemon.imageUrl,
            fallbackUrl: pokemon.subImageUrl) { image in
                image
                    .resizable()
                    .shadow(color: Color(.shadow), radius: RadiusToken.s, x: -4, y: 4)
                    .aspectRatio(AspectToken.square.value, contentMode: .fill)
                    .frame(maxWidth: .infinity)
            } placeholder: {
                placeholder()
            } errorView: { _ in
                errorView()
            }
    }

    private func pokemonInformation(_ pokemon: Pokemon) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: SpaceToken.xs) {
                Text("\(pokemon.name)")
                    .fontWithLineHeight(token: .captionTwoSemibold)
                    .foregroundStyle(Color(.labelPrimary))
                    .lineLimit(1)
                Text("No.\(pokemon.number)")
                    .fontWithLineHeight(token: .captionTwoRegular)
                    .foregroundStyle(Color(.labelSecondary))
                    .lineLimit(1)
            }
            Spacer()
        }
    }

    private func errorView() -> some View {
        CenteringView {
            Image(systemSymbol: .xmarkOctagonFill)
                .resizable()
                .frame(width: 16, height: 16)
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(AspectToken.square.value, contentMode: .fill)
    }

    private func placeholder() -> some View {
        CenteringView {
            Image(.pokeBall)
                .resizable()
                .frame(width: 64, height: 64)
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(AspectToken.square.value, contentMode: .fill)
    }

    private func emptyView() -> some View {
        GeometryReader { geometry in
            ScrollView {
                CenteringView {
                    Image(.pokeBall)
                        .resizable()
                        .frame(width: 64, height: 64)
                        .rotationEffect(.degrees(state.isEmptyViewAnimating ? 360 : 0))
                        .animation(
                            .linear(duration: 0.5).repeatForever(autoreverses: false),
                            value: state.isLoading
                        )
                        .task {
                            try? await Task.sleep(for: .seconds(0.2))
                            state.updateIsEmptyViewAnimating(true)
                        }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .refreshable {
                await state.refresh()
            }
        }
    }
}

#Preview {
    PokemonListView(
        router: Router(
            isPresented: .constant(.root)
        ),
        input: .init(
            withNavigation: true
        ),
        trigger: nil
    )
}
