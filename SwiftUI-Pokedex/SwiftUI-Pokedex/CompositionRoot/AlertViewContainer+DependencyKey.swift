//
//  AlertViewContainer+DependencyKey.swift
//  SwiftUI-Pokedex
//
//  Created by ykkd on 2024/10/20.
//

import Dependencies
import DependencyContainer
import RootScreen
import Router
import SwiftUI

extension AlertViewContainer: @retroactive DependencyKey {

    public static var liveValue: Self {
        .init { router, input in
            AnyView(
                RootView(router: router as! Router, input: input)
            )
        }
    }
}
