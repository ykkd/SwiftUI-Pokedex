//
//  ScaleAnimationView.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/21.
//

import SwiftUI

public struct ScaleAnimationView<C: View>: View {

    let scaleFrom: CGFloat
    let scaleTo: CGFloat
    let animation: Animation
    let content: C

    @State private var isStarted: Bool = false

    public init(
        scaleFrom: CGFloat,
        scaleTo: CGFloat,
        animation: Animation = .easeInOut,
        content: C
    ) {
        self.scaleFrom = scaleFrom
        self.scaleTo = scaleTo
        self.animation = animation
        self.content = content
    }

    public var body: some View {
        content
            .scaleEffect(isStarted ? scaleTo : scaleFrom)
            .animation(.easeInOut, value: isStarted)
            .onAppear {
                isStarted = true
            }
    }
}
