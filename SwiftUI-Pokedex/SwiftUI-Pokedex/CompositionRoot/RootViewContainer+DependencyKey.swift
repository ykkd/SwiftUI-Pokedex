//
//  RootViewContainer+DependencyKey.swift
//  SwiftUI-Pokedex
//
//  Created by ykkd on 2024/10/13.
//

import Dependencies
import DependencyContainer
import RootScreen
import SwiftUI

extension RootViewContainer: @retroactive DependencyKey {

    public static var liveValue: Self {
        .init {
            AnyView(
                RootView()
            )
        }
    }
}
