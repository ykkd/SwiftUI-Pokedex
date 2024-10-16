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
            let item = GridItem(spacing: SpaceToken.s)
            let itemCount = 3
            let columns: [GridItem] = Array(repeating: item, count: itemCount)

            ScrollView(.vertical) {
                LazyVGrid(columns: columns, spacing: SpaceToken.s) {
                    ForEach(state.pokemons) { pokemon in
                        VStack(spacing: SpaceToken.s) {
                            AsyncImage(url: pokemon.imageUrl) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .shadow(color: Color(.shadow), radius: RadiusToken.s, x: -4, y: 4)
                                        .aspectRatio(AspectToken.square.value, contentMode: .fill)
                                        .frame(maxWidth: .infinity)
                                } else if phase.error != nil {
                                    VStack {
                                        Spacer()
                                        HStack {
                                            Spacer()
                                            Image(systemSymbol: .xmarkOctagonFill)
                                                .resizable()
                                                .frame(width: 16, height: 16)
                                            Spacer()
                                        }
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .aspectRatio(AspectToken.square.value, contentMode: .fill)
                                } else {
                                    VStack {
                                        Spacer()
                                        HStack {
                                            Spacer()
                                            Image(.pokeBall)
                                                .resizable()
                                            Spacer()
                                        }
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .aspectRatio(AspectToken.square.value, contentMode: .fill)
                                }
                            }
                            Divider()
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
                        .padding(SpaceToken.s)
                        .aspectRatio(AspectToken.square.value, contentMode: .fit)
                        .background(Color(.systemBackground))
                        .cornerRadius(RadiusToken.l)
                    }
                }
                .padding(.horizontal, SpaceToken.m)
            }
            .navigationTitle("Pokedex")
            .background(Color(.systemBackgroundSecondary))
        }
        .task {
            await state.getData(100, offset: 0)
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
