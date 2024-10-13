//
//  MainLoggerContainer+DependencyKey.swift
//  SwiftUI-Pokedex
//
//  Created by ykkd on 2024/10/14.
//

import Dependencies
import DependencyContainer
import os.log

extension MainLoggerContainer: @retroactive DependencyKey {

    public static var liveValue: Self {
        .init()
    }
}
