//
//  OriginalRefreshable.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/17.
//

private import Refreshable
import SwiftUI

// MARK: - RefreshableScrollView
struct RefreshableScrollView: ViewModifier {
    let spaceName: String
    let onRefresh: () async -> Void

    func body(content: Content) -> some View {
        ScrollView {
            RefreshControl(coordinateSpace: .named(spaceName)) {
                Task {
                    await onRefresh()
                }
            }
            content
        }
        .coordinateSpace(name: spaceName)
    }
}

extension View {

    public func refreshableScrollView(spaceName: String, action: @escaping () async -> Void) -> some View {
        ModifiedContent(
            content: self,
            modifier: RefreshableScrollView(
                spaceName: spaceName,
                onRefresh: action
            )
        )
    }
}
