//
//  RouterView.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/14.
//

import Entity
import Foundation
import RouterCore
import SwiftUI

public struct RouterView<Content: View>: View {

    @StateObject private var router: Router

    private let withNavigation: Bool

    private let content: Content

    public init(
        router: Router,
        withNavigation: Bool,
        @ViewBuilder content: @escaping () -> Content
    ) {
        _router = StateObject(wrappedValue: router)
        self.withNavigation = withNavigation
        self.content = content()
    }

    public var body: some View {
        content(withNavigation)
            .sheet(item: router.presentingSheet) { screen in
                router.view(screen, transition: .sheet)
            }
            .fullScreenCover(item: router.presentingFullScreen) { screen in
                router.view(screen, transition: .fullScreen)
            }
    }

    @ViewBuilder
    private func content(_ withNavigation: Bool) -> some View {
        if withNavigation {
            NavigationStack(path: router.navigationPath) {
                content
                    .navigationDestination(for: Screen.self) { screen in
                        router.view(screen, transition: .push)
                    }
            }
        } else {
            content
                .navigationDestination(for: Screen.self) { screen in
                    router.view(screen, transition: .push)
                }
        }
    }
}
