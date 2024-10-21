//
//  BaseRouter.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/14.
//

import Entity
import SwiftUI

// MARK: - BaseRouter
@MainActor
open class BaseRouter: Sendable, ObservableObject {

    @Published private(set) var state: RouterState

    public init(isPresented: Binding<Screen?>) {
        state = RouterState(isPresented: isPresented)
    }

    open func view(_ screen: Screen, transition: ScreenTransition) -> AnyView {
        AnyView(EmptyView())
    }
}

extension BaseRouter {

    public func push(to screen: Screen) {
        state.navigationPath.append(screen)
    }

    public func pop() {
        state.navigationPath.removeLast()
    }

    public func present(sheet screen: Screen) {
        state.presentingSheet = screen
    }

    public func present(fullScreen screen: Screen, withAnimation: Bool = true) {
        if withAnimation {
            state.presentingFullScreen = screen
        } else {
            var transaction = Transaction()
            transaction.disablesAnimations = true

            withTransaction(transaction) {
                state.presentingFullScreen = screen
            }
        }
    }

    public func presentAlertView(error: ApplicationError, buttons: [AlertButtonType]) {
        let screen: Screen = .alert(error: error, buttons: buttons)
        present(fullScreen: screen, withAnimation: false)
    }

    public func dismiss(withAnimation: Bool = true) {
        if withAnimation {
            dismiss()
        } else {
            var transaction = Transaction()
            transaction.disablesAnimations = true

            withTransaction(transaction) {
                dismiss()
            }
        }
    }

    private func dismiss() {
        if state.presentingSheet != nil {
            state.presentingSheet = nil
        } else if state.presentingFullScreen != nil {
            state.presentingFullScreen = nil
        } else if state.navigationPath.count > 0 {
            state.navigationPath.removeLast()
        } else {
            state.isPresented.wrappedValue = nil
        }
    }
}

extension BaseRouter {

    public var navigationPath: Binding<[Screen]> {
        binding(keyPath: \.navigationPath)
    }

    public var presentingSheet: Binding<Screen?> {
        binding(keyPath: \.presentingSheet)
    }

    public var presentingFullScreen: Binding<Screen?> {
        binding(keyPath: \.presentingFullScreen)
    }

    public var isPresented: Binding<Screen?> {
        state.isPresented
    }

    public var isRootScreenVisible: Binding<Bool> {
        Binding(
            get: { !self.state.isPresenting && self.state.navigationPath.isEmpty },
            set: { _ in }
        )
    }
}

extension BaseRouter {

    private func binding<T>(keyPath: WritableKeyPath<RouterState, T>) -> Binding<T> {
        Binding(
            get: {
                self.state[keyPath: keyPath]
            },
            set: {
                self.state[keyPath: keyPath] = $0
            }
        )
    }
}

// MARK: - WritableKeyPath + Sendable
extension WritableKeyPath: @retroactive @unchecked Sendable {}
