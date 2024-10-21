//
//  AlertView.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/20.
//

import Entity
import Router
import SwiftUI
private import SFSafeSymbols
private import DesignSystem

public struct AlertView: View {

    @StateObject private var router: Router

    @State var isPresentedAlert = false

    private let input: CommonScreenInput
    private let error: ApplicationError
    private let buttons: [AlertButtonType]

    public init(
        router: Router,
        input: CommonScreenInput,
        error: ApplicationError,
        buttons: [AlertButtonType]
    ) {
        _router = StateObject(wrappedValue: router)
        self.input = input
        self.error = error
        self.buttons = buttons
    }

    public var body: some View {
        RouterView(
            router: router,
            withNavigation: input.withNavigation
        ) {
            EmptyView()
        }
        .ignoresSafeArea()
        .presentationBackground(.clear)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                isPresentedAlert = true
            }
        }
        .alert(
            isPresented: $isPresentedAlert,
            error: error,
            actions: { _ in
                ForEach(buttons) { button in
                    Button(button.title, role: button.role) {
                        router.dismiss(withAnimation: false)
                        button.action?()
                    }
                }
            },
            message: { error in
                if error.alertMessage.isEmpty {
                    EmptyView()
                } else {
                    Text(error.alertMessage)
                }
            }
        )
    }
}
