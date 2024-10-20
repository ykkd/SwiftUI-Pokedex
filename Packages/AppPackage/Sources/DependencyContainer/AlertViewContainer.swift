//
//  AlertViewContainer.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/20.
//

import Dependencies
import Entity
import RouterCore
import SwiftUI

// MARK: - AlertViewContainer
public struct AlertViewContainer: Sendable {

    public var view: @MainActor @Sendable (
        _ router: BaseRouter,
        _ input: CommonScreenInput
    ) -> AnyView

    public init(
        view: @escaping @MainActor @Sendable (
            _ router: BaseRouter,
            _ input: CommonScreenInput
        ) -> AnyView
    ) {
        self.view = view
    }
}

// MARK: TestDependencyKey
extension AlertViewContainer: TestDependencyKey {

    public static var testValue: Self {
        .init(view: unimplemented("", placeholder: AnyView(Text("TestValue of AlertView"))))
    }
}

extension DependencyValues {

    public var alertViewContainer: AlertViewContainer {
        get { self[AlertViewContainer.self] }
        set { self[AlertViewContainer.self] = newValue }
    }
}
