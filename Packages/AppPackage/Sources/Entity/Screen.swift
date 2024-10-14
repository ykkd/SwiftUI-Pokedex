//
//  Screen.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/14.
//

import Foundation

// MARK: - Screen
public enum Screen: Equatable, Hashable {
    case root(CommonInput)
}

// MARK: Identifiable
extension Screen: Identifiable {

    public var id: Self { self }
}

// MARK: Screen.CommonInput
extension Screen {

    public struct CommonInput: Equatable, Hashable {

        public let withNavigation: Bool

        public init(withNavigation: Bool) {
            self.withNavigation = withNavigation
        }
    }
}
