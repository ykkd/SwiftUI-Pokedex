//
//  Router.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/14.
//

import Dependencies
import DependencyContainer
import Entity
import RouterCore
import SwiftUI

// MARK: - Router
public final class Router: BaseRouter {

    @Dependency(\.rootViewContainer) private var rootViewContainer

    override public func view(
        _ screen: Screen,
        transition: ScreenTransition
    ) -> AnyView {
        AnyView(buildView(screen: screen, transition: transition))
    }
}

extension Router {

    @ViewBuilder
    private func buildView(
        screen: Screen,
        transition: ScreenTransition
    ) -> some View {
        switch screen {
        case .root:
            rootViewContainer.view(
                router(transition: transition),
                CommonScreenInput(withNavigation: transition.withNavigation)
            )
        }
    }

    private func router(transition: ScreenTransition) -> Router {
        switch transition {
        case .push,
             .alert:
            self
        case .sheet:
            Router(isPresented: presentingSheet)
        case .fullScreen:
            Router(isPresented: presentingFullScreen)
        }
    }
}
