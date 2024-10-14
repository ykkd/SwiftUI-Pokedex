//
//  RootView.swift
//  Presentation
//
//  Created by ykkd on 2024/10/12.
//

private import Dependencies
private import DependencyContainer
import Entity
import Router
import SwiftUI

public struct RootView: View {

    @Dependency(\.mainLoggerContainer) private var mainLogger
    @StateObject private var router: Router

    private let input: CommonScreenInput

    public init(
        router: Router,
        input: CommonScreenInput
    ) {
        _router = StateObject(wrappedValue: router)
        self.input = input
    }

    public var body: some View {
        RouterView(
            router: router,
            withNavigation: input.withNavigation
        ) {
            Text("RootView")
            Button("Push Root") {
                router.push(to: .root)
            }
            Button("Present Root(fullScreen)") {
                mainLogger.log(.info, message: "hige")
                router.present(fullScreen: .root)
            }
            Button("Present Root(sheet)") {
                mainLogger.log(.info, message: "hige")
                router.present(sheet: .root)
            }
            Button("dismiss") {
                router.dismiss()
            }
        }
    }
}

#Preview {
    RootView(
        router: Router(
            isPresented: .constant(.root)
        ),
        input: .init(
            withNavigation: true
        )
    )
}
