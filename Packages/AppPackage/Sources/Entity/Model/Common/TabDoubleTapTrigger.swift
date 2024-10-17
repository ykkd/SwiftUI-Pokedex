//
//  TabDoubleTapTrigger.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/17.
//

import Foundation

public struct TabDoubleTapTrigger: Equatable, Hashable {

    public private(set) var key: Bool = false

    public init() {}

    public mutating func fire() {
        key.toggle()
    }
}
