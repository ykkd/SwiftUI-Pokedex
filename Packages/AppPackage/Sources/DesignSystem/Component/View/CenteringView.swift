//
//  CenteringView.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/16.
//

import SwiftUI

public struct CenteringView<Content: View>: View {

    let content: () -> Content

    public var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                content()
                Spacer()
            }
            Spacer()
        }
    }
}
