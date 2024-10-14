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
            List(state.pokemons) { pokemon in
                Text("\(pokemon.name)")
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
