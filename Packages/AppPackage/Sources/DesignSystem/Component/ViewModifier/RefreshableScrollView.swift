//
//  RefreshableScrollView.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/17.
//

private import Refreshable
import Entity
import ScreenExtension
import SwiftUI

// MARK: - RefreshableScrollView
public struct RefreshableScrollView: ViewModifier {

    public let spaceName: String

    public let trigger: TabDoubleTapTrigger?

    public let isCurrent: Binding<Bool>?

    public let onRefresh: () async -> Void

    @State private var executeHaptics: Bool = false

    private var scrollViewId: String {
        "ScrollView-\(spaceName)"
    }

    public func body(content: Content) -> some View {
        ScrollViewReader { proxy in
            ScrollView {
                RefreshControl(coordinateSpace: .named(spaceName)) {
                    Task {
                        executeHaptics.toggle()
                        await onRefresh()
                    }
                }
                .id(scrollViewId)
                content
            }
            .onTrigger(of: trigger) {
                print("isCurrent: \(isCurrent)")
                if let isCurrent,
                   isCurrent.wrappedValue {
                    withAnimation {
                        proxy.scrollTo(scrollViewId, anchor: .top)
                    }
                }
            }
            .coordinateSpace(name: spaceName)
            .sensoryFeedback(.impact, trigger: executeHaptics)
        }
    }
}

extension View {

    public func refreshableScrollView(
        spaceName: String,
        trigger: TabDoubleTapTrigger? = nil,
        isCurrent: Binding<Bool>? = nil,
        action: @escaping () async -> Void
    ) -> some View {
        ModifiedContent(
            content: self,
            modifier: RefreshableScrollView(
                spaceName: spaceName,
                trigger: trigger,
                isCurrent: isCurrent,
                onRefresh: action
            )
        )
    }
}
