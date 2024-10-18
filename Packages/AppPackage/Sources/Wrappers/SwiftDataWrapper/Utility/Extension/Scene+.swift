//
//  Scene+.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/19.
//

import SwiftData
import SwiftUI

extension Scene {

    public func setupSwiftData() -> some Scene {
        modelContainer(for: [PokemonModel.self])
    }
}
