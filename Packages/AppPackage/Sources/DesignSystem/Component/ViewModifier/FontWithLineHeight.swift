//
//  FontWithLineHeight.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/16.
//

import SwiftUI

// MARK: - FontWithLineHeight
struct FontWithLineHeight: ViewModifier {
    let font: UIFont
    let lineHeight: CGFloat

    func body(content: Content) -> some View {
        content
            .font(Font(font))
            .lineSpacing(lineHeight - font.lineHeight)
            .padding(.vertical, (lineHeight - font.lineHeight) / 2)
    }
}

extension Text {

    public func fontWithLineHeight(token: TypographyToken) -> some View {
        ModifiedContent(
            content: self,
            modifier: FontWithLineHeight(
                font: token.uiFont,
                lineHeight: token.lineHeight
            )
        )
    }
}
