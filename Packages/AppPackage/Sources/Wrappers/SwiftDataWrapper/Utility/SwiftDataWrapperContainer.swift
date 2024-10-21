//
//  SwiftDataWrapperContainer.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/19.
//

import Dependencies
import Foundation
import SwiftUI

// MARK: - SwiftDataWrapperContainer
public struct SwiftDataWrapperContainer: Sendable {

    public var container: @Sendable () async -> SwiftDataWrapper

    public init(
        container: @escaping @Sendable () async -> SwiftDataWrapper
    ) {
        self.container = container
    }
}

// MARK: DependencyKey
extension SwiftDataWrapperContainer: DependencyKey {

    public static var liveValue: Self {
        .init {
            await SwiftDataWrapper()
        }
    }
}

extension DependencyValues {

    public var swiftDataWrapperContainer: SwiftDataWrapperContainer {
        get { self[SwiftDataWrapperContainer.self] }
        set { self[SwiftDataWrapperContainer.self] = newValue }
    }
}
