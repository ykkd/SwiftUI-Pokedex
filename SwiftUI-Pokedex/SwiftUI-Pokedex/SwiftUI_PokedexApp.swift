//
//  SwiftUI_PokedexApp.swift
//  SwiftUI-Pokedex
//
//  Created by ykkd on 2024/10/12.
//

import Dependencies
import RootScreen
import SwiftUI

@main
struct SwiftUI_PokedexApp: App {

    @Dependency(\.rootViewContainer) private var rootViewContainer

    var body: some Scene {
        WindowGroup {
            rootViewContainer.rootView()
        }
    }
}
