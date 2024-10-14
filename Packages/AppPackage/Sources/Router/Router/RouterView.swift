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

    private let content: Content

    public init(
        router: Router,
        @ViewBuilder content: @escaping () -> Content
    ) {
        _router = StateObject(wrappedValue: router)
        self.content = content()
    }

    public var body: some View {
        NavigationStack(path: router.navigationPath) {
            content
                .navigationDestination(for: Screen.self) { screen in
                    router.view(screen, transition: .push)
                }
        }.sheet(item: router.presentingSheet) { screen in
            router.view(screen, transition: .sheet)
        }.fullScreenCover(item: router.presentingFullScreen) { screen in
            router.view(screen, transition: .fullScreen)
        }
    }
}
