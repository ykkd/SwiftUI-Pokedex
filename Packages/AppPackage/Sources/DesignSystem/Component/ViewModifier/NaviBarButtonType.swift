//
//  NaviBarButtonType.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/18.
//

import Entity
import SFSafeSymbols
import SwiftUI

// MARK: - NaviBarLeadingButton
public struct NaviBarLeadingButton: ViewModifier {
    public let type: NaviBarButtonType?
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

    public func naviBarLeadingButton(type: NaviBarButtonType?, action: (() -> Void)?) -> some View {
        ModifiedContent(
            content: self,
            modifier: NaviBarLeadingButton(
                type: type,
                action: action
            )
        )
    }
}
