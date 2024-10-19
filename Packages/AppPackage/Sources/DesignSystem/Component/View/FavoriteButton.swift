//
//  FavoriteButton.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/20.
//

import SwiftUI

public struct FavoriteButton: View {
    @State private var isFavorited: Bool

    private var animationScale: CGFloat {
        isFavorited ? 1.2 : 1.0
    }

    private var foregoundColor: Color {
        isFavorited ? heartColor : bgColor
    }

    private var fillColor: Color {
        (isFavorited ? heartColor : bgColor).opacity(0.2)
    }

    private let heartColor = Color(.systemRed)
    private let bgColor = Color(.systemGray)

    private let action: ((Bool) -> Void)?

    public init(
        isFavorited: Bool = false,
        action: ((Bool) -> Void)?
    ) {
        self.isFavorited = isFavorited
        self.action = action
    }

    public var body: some View {
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                isFavorited.toggle()
                action?(isFavorited)
            }
        } label: {
            ZStack {
                Circle()
                    .fill(fillColor)
                    .frame(width: 60, height: 60)
                Image(systemSymbol: isFavorited ? .heartFill : .heart)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(foregoundColor)
                    .scaleEffect(animationScale)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
