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
            EmptyView()
        }
    }
}

#Preview {
    AlertView(
        router: Router(
            isPresented: .constant(.alert)
        ),
        input: .init(
            withNavigation: false,
            naviBarLeadingButtonType: nil
        )
    )
}
