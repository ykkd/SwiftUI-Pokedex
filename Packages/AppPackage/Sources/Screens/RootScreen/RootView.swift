//
//  RootView.swift
//  Presentation
//
//  Created by ykkd on 2024/10/12.
//

private import Dependencies
private import DependencyContainer
import Entity
import Router
import SwiftUI
private import SFSafeSymbols
private import DesignSystem

public struct RootView: View {

    @Dependency(\.pokemonListViewContainer) private var pokemonListViewContainer

    @StateObject private var router: Router

    @State private var selectedTab = RootTab.pokemonList

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
            TabView(selection: $selectedTab) {
                router.buildTabView(.pokemonList)
                    .tag(RootTab.pokemonList)
                    .tabItem {
                        Image(systemSymbol: .squareGrid2x2Fill)
                    }
            }
            .tint(Color(.labelPrimary))
        }
        .ignoresSafeArea()
    }
}

#Preview {
    RootView(
        router: Router(
            isPresented: .constant(.root)
        ),
        input: .init(
            withNavigation: true
        )
    )
}
