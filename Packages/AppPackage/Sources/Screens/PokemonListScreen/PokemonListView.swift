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

            ScrollView {
                LazyVGrid(columns: columns, spacing: SpaceToken.s) {
                    ForEach(state.pokemons) { pokemon in
                        VStack(spacing: SpaceToken.xs) {
                            AsyncImage(url: pokemon.imageUrl) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(1.0, contentMode: .fill)
                                        .frame(maxWidth: .infinity)
                                } else if phase.error != nil {
                                    VStack {
                                        Spacer()
                                        HStack {
                                            Spacer()
                                            Image(systemName: "xmark.octagon")
                                                .resizable()
                                                .frame(width: 16, height: 16)
                                                .aspectRatio(1.0, contentMode: .fill)
                                            Spacer()
                                        }
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity)
                                } else {
                                    VStack {
                                        Spacer()
                                        HStack {
                                            Spacer()
                                            Image(.pokeBall)
                                                .resizable()
                                                .aspectRatio(1.0, contentMode: .fill)
                                            Spacer()
                                        }
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            Text("\(pokemon.name)")
                                .fontWithLineHeight(token: .bodyRegular)
                        }
                        .aspectRatio(1.0, contentMode: .fit)
                    }
                }
            }
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
