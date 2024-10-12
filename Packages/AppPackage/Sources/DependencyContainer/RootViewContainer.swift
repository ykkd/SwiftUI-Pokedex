//
//  RootViewContainer.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/13.
//

import Dependencies
import SwiftUI

// MARK: - RootViewContainer
public struct RootViewContainer: Sendable {

    public var rootView: @MainActor @Sendable () -> AnyView

    public init(rootView: @escaping @MainActor @Sendable () -> AnyView) {
        self.rootView = rootView
    }
}

// MARK: TestDependencyKey
extension RootViewContainer: TestDependencyKey {

    public static var testValue: Self {
        .init(rootView: unimplemented("", placeholder: AnyView(Text("TestValue of RootView"))))
    }
}

extension DependencyValues {

    public var rootViewContainer: RootViewContainer {
        get { self[RootViewContainer.self] }
        set { self[RootViewContainer.self] = newValue }
    }
}
