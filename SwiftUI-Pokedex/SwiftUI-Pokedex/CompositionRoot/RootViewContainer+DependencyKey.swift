//
//  RootViewContainer+DependencyKey.swift
//  SwiftUI-Pokedex
//
//  Created by ykkd on 2024/10/13.
//

public import Dependencies
public import DependencyContainer
import RootScreen
import Router
import SwiftUI

extension RootViewContainer: @retroactive DependencyKey {

    public static var liveValue: Self {
        .init { router, input in
            AnyView(
                RootView(router: router as! Router, input: input)
            )
        }
    }
}
