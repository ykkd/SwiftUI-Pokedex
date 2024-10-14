//
//  Screen.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/14.
//

import Foundation

// MARK: - Screen
public enum Screen: Equatable, Hashable {
    case root
    case pokemonList
}

// MARK: Identifiable
extension Screen: Identifiable {

    public var id: Self { self }
}
