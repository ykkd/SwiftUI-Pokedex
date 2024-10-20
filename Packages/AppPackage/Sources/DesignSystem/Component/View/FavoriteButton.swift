//
//  FavoriteButton.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/20.
//

private import SFSafeSymbols
import SwiftUI

public struct FavoriteButton: View {

    @Binding private var isFavorite: Bool

    private var animationScale: CGFloat {
        isFavorite ? 1.2 : 1.0
    }

    private var foregoundColor: Color {
        isFavorite ? heartColor : bgColor
    }

    private var fillColor: Color {
        (isFavorite ? heartColor : bgColor).opacity(0.2)
    }

    private let heartColor = Color(.systemRed)
    private let bgColor = Color(.systemGray)

    private let action: ((Bool) -> Void)?

    public init(
        isFavorite: Binding<Bool>,
        action: ((Bool) -> Void)?
    ) {
        _isFavorite = isFavorite
        self.action = action
    }

    public var body: some View {
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                action?(!isFavorite)
            }
        } label: {
            ZStack {
                Circle()
                    .fill(fillColor)
                    .frame(width: 60, height: 60)
                Image(systemSymbol: isFavorite ? .heartFill : .heart)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(foregoundColor)
                    .scaleEffect(animationScale)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
