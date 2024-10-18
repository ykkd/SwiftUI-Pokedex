//
//  View+.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/16.
//

import SwiftUI

extension View {

    public func hidden(_ hidden: Bool) -> some View {
        hidden ? nil : self
    }

    @ViewBuilder
    public func when(
        _ condition: Bool,
        @ViewBuilder transform: (Self) -> some View
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
