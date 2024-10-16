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

    public init(
        router: Router,
        input: CommonScreenInput
    ) {
        _router = StateObject(wrappedValue: router)
        self.input = input
    }

    public var body: some View {
        RouterView(
            router: router,
            withNavigation: input.withNavigation
        ) {
            content()
                .task {
                    await state.getInitialData()
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
            .padding(.horizontal, SpaceToken.m)
        }
        .navigationTitle(RootTab.pokemonList.navigationTitle)
        .background(Color(.systemBackgroundSecondary))
    }

    @ViewBuilder
    private func itemView(_ pokemon: Pokemon) -> some View {
        VStack(spacing: SpaceToken.s) {
            pokemonImage(pokemon.imageUrl)
            Divider()
            pokemonInformation(pokemon)
        }
        .padding(SpaceToken.s)
        .aspectRatio(AspectToken.square.value, contentMode: .fit)
        .background(Color(.systemBackground))
        .cornerRadius(RadiusToken.l)
    }

    @ViewBuilder
    private func pokemonImage(_ imageUrl: URL) -> some View {
        AsyncImage(url: imageUrl) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .shadow(color: Color(.shadow), radius: RadiusToken.s, x: -4, y: 4)
                    .aspectRatio(AspectToken.square.value, contentMode: .fill)
                    .frame(maxWidth: .infinity)
            } else if phase.error != nil {
                CenteringView {
                    Image(systemSymbol: .xmarkOctagonFill)
                        .resizable()
                        .frame(width: 16, height: 16)
                }
                .frame(maxWidth: .infinity)
                .aspectRatio(AspectToken.square.value, contentMode: .fill)
            } else {
                CenteringView {
                    Image(.pokeBall)
                        .resizable()
                }
                .frame(maxWidth: .infinity)
                .aspectRatio(AspectToken.square.value, contentMode: .fill)
            }
        }
    }

    @ViewBuilder
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
}

#Preview {
    PokemonListView(
        router: Router(
            isPresented: .constant(.root)
        ),
        input: .init(
            withNavigation: true
        )
    )
}
