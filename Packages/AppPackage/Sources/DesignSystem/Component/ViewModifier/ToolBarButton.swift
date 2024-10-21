//
//  ToolBarButton.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/18.
//

import Entity
import SFSafeSymbols
import SwiftUI

// MARK: - ToolBarButton
public struct ToolBarButton: ViewModifier {
    public let placement: ToolbarItemPlacement
    public let type: ToolbarButtonType?
    public let action: (() -> Void)?

    @ViewBuilder
    public func body(content: Content) -> some View {
        if let type {
            content
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            action?()
                        } label: {
                            HStack {
                                switch type {
                                case .back:
                                    Image(systemSymbol: .chevronLeft)
                                case .close:
                                    Image(systemSymbol: .xmark)
                                }
                            }
                        }
                    }
                }
        } else {
            content
        }
    }
}

extension View {

    public func toolBarButton(
        placement: ToolbarItemPlacement,
        type: ToolbarButtonType?,
        action: (() -> Void)?
    ) -> some View {
        ModifiedContent(
            content: self,
            modifier: ToolBarButton(
                placement: placement,
                type: type,
                action: action
            )
        )
    }
}
