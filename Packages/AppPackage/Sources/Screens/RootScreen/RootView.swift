//
//  RootView.swift
//  Presentation
//
//  Created by ykkd on 2024/10/12.
//

import Entity
import Router
import SwiftUI
private import SFSafeSymbols
private import DesignSystem

// MARK: - RootView
public struct RootView: View {

    @StateObject private var router: Router

    @State private var selectedTab = RootTab.pokemonList

    @State private var tabDoubleTapTriggers: [RootTab: TabDoubleTapTrigger] = .init(
        uniqueKeysWithValues: RootTab.allCases.map { ($0, .init()) }
    )

    private let input: CommonScreenInput

    private var selectedTabBinding: Binding<RootTab> {
        Binding(
            get: { selectedTab },
            set: {
                if $0 == selectedTab {
                    tabDoubleTapTriggers[selectedTab]?.fire()
                }
                selectedTab = $0
            }
        )
    }

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
            TabView(selection: selectedTabBinding) {
                router.buildTabView(.pokemonList, trigger: tabDoubleTapTriggers[.pokemonList])
                    .tag(RootTab.pokemonList)
                    .tabItem {
                        Image(systemSymbol: .squareGrid2x2Fill)
                    }
                router.buildTabView(.favoritePokemonList, trigger: tabDoubleTapTriggers[.favoritePokemonList])
                    .tag(RootTab.favoritePokemonList)
                    .tabItem {
                        Image(systemSymbol: .heartFill)
                    }
            }
            .tint(Color(.labelPrimary))
        }
        .ignoresSafeArea()
    }
}

extension RootView {

    private func didDoubleTapTab(for tab: RootTab) {
        tabDoubleTapTriggers[tab]?.fire()
    }
}

#Preview {
    RootView(
        router: Router(
            isPresented: .constant(.root)
        ),
        input: .init(
            withNavigation: true,
            naviBarLeadingButtonType: nil
        )
    )
}
