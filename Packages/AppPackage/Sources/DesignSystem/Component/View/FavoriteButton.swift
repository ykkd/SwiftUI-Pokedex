//
//  FavoriteButton.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/20.
//

import SwiftUI

public struct FavoriteButton: View {
    @State private var isFavorited: Bool
    @State private var animationScale: CGFloat

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
        animationScale: CGFloat = 1.0,
        action: ((Bool) -> Void)?
    ) {
        self.isFavorited = isFavorited
        self.animationScale = animationScale
        self.action = action
    }

    public var body: some View {
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                isFavorited.toggle()
                animationScale = isFavorited ? 1.3 : 1.0
                action?(isFavorited)
            }
        } label: {
            ZStack {
                Circle()
                    .fill(fillColor)
                    .frame(width: 60, height: 60)
                Image(systemSymbol: isFavorited ? .heartFill : .heart)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(foregoundColor)
                    .scaleEffect(animationScale)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
