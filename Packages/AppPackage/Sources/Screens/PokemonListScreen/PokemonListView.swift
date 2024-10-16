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

    private func itemView(_ pokemon: Pokemon) -> some View {
        VStack(spacing: SpaceToken.s) {
            pokemonImage(pokemon)
            Divider()
            pokemonInformation(pokemon)
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
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(AspectToken.square.value, contentMode: .fill)
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

// MARK: - FallbackableAsyncImage
public struct FallbackableAsyncImage<C: View, P: View, E: View>: View {

    public let content: (Image) -> C
    public let placeholder: (() -> P)?
    public let errorView: ((any Error) -> E)?

    private let primaryUrl: URL?
    private let fallbackUrl: URL?

    @State private var needsFallback: Bool = false

    public init(
        _ primaryUrl: URL?,
        fallbackUrl: URL?,
        content: @escaping (Image) -> C,
        placeholder: @escaping () -> P,
        errorView: @escaping (any Error) -> E
    ) {
        self.primaryUrl = primaryUrl
        self.fallbackUrl = fallbackUrl
        self.content = content
        self.placeholder = placeholder
        self.errorView = errorView
    }

    public var body: some View {
        if needsFallback {
            asyncImage(fallbackUrl)
        } else {
            asyncImage(primaryUrl) {
                needsFallback = true
            }
        }
    }

    private func asyncImage(_ url: URL?, onError: (() -> Void)? = nil) -> some View {
        AsyncImage(url: url) { phase in
            if let image = phase.image {
                content(image)
            } else if let error = phase.error {
                if let errorView {
                    errorView(error)
                        .onAppear {
                            onError?()
                        }
                } else {
                    EmptyView()
                        .onAppear {
                            onError?()
                        }
                }
            } else {
                if let placeholder {
                    placeholder()
                } else {
                    ProgressView()
                }
            }
        }
    }
}
