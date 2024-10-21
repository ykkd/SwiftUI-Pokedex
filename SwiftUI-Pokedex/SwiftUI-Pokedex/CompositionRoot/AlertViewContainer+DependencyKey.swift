//
//  AlertViewContainer+DependencyKey.swift
//  SwiftUI-Pokedex
//
//  Created by ykkd on 2024/10/20.
//

import AlertScreen
public import Dependencies
public import DependencyContainer
import Router
import SwiftUI

extension AlertViewContainer: @retroactive DependencyKey {

    public static var liveValue: Self {
        .init { router, input, error, buttons in
            AnyView(
                AlertView(
                    router: router as! Router,
                    input: input,
                    error: error,
                    buttons: buttons
                )
            )
        }
    }
}
