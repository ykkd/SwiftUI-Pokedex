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
                .when(state.shouldShowEmptyView) { _ in
                    emptyView()
                }
                .task {
                    await getInitialData()
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

        LazyVGrid(columns: columns, spacing: SpaceToken.s) {
            ForEach(state.pokemons) { pokemon in
                ScaleAnimationView(
                    scaleFrom: 0.1,
                    scaleTo: 1.0,
                    animation: .easeInOut,
                    content: itemView(pokemon)
                )
                .task {
                    await getNextPageIfNeeded(last: pokemon)
                }
            }
        }
        .overlay(alignment: .bottom) {
            ProgressView()
                .frame(height: 60)
                .hidden(state.shouldShowBottomProgress)
        }
        .padding(.horizontal, SpaceToken.m)
        .refreshableScrollView(spaceName: "PokemonList") {
            await refresh()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(RootTab.pokemonList.navigationTitle)
        .background(Color(.systemBackgroundSecondary))
    }

    private func itemView(_ pokemon: Pokemon) -> some View {
        Button {
            router.push(to: .pokemonDetail(number: pokemon.number))
        } label: {
            VStack(spacing: SpaceToken.s) {
                pokemonImage(pokemon)
                Divider()
                pokemonInformation(pokemon)
            }
        }
        .padding(SpaceToken.s)
        .aspectRatio(AspectToken.square.value, contentMode: .fit)
        .background(Color(.systemBackgroundPrimary))
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
                placeholder() as! AnyView
            } errorView: { _ in
                errorView() as! AnyView
            }
    }

    private func pokemonInformation(_ pokemon: Pokemon) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: SpaceToken.xs) {
                Text("\(pokemon.name.initialLetterUppercased())")
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
            CenteringView {
                ProgressView()
                    .frame(width: 64, height: 64)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .refreshableScrollView(spaceName: "PokemonListEmptyState") {
                await refresh()
            }
        }
    }
}

// MARK: - Error handling
extension PokemonListView {

    private func getInitialData() async {
        do {
            try await state.getInitialData()
        } catch {
            router.presentAlertView(
                error: error,
                buttons: [
                    .ok(action: nil),
                    .retry {
                        Task {
                            await getInitialData()
                        }
                    },
                ]
            )
        }
    }

    private func refresh() async {
        do {
            try? await Task.sleep(for: .seconds(1.0))
            try await state.refresh()
        } catch {
            router.presentAlertView(
                error: error,
                buttons: [
                    .ok(action: nil),
                    .retry {
                        Task {
                            await refresh()
                        }
                    },
                ]
            )
        }
    }

    private func getNextPageIfNeeded(last: Pokemon) async {
        do {
            try await state.getNextPageIfNeeded(last: last)
        } catch {
            router.presentAlertView(
                error: error,
                buttons: [
                    .ok(action: nil),
                    .retry {
                        Task {
                            await getNextPageIfNeeded(last: last)
                        }
                    },
                ]
            )
        }
    }
}

#Preview {
    PokemonListView(
        router: Router(
            isPresented: .constant(.root)
        ),
        input: .init(
            withNavigation: true,
            naviBarLeadingButtonType: nil
        )
    )
}
