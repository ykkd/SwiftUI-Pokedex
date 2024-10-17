//
//  ScreenSizeCalculator.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/18.
//

import Foundation
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

// MARK: - ScreenSizeCalculator
@MainActor
public enum ScreenSizeCalculator {

    public static func calculate() -> ScreenSize {
        #if os(iOS)
        let size = UIScreen.main.bounds.size
        return .init(width: size.width, height: size.height)
        #elseif os(macOS)
        let size = NSScreen.main?.frame
        return .init(width: size?.width ?? .zero, height: size?.height ?? .zero)
        #endif
    }
}

// MARK: ScreenSizeCalculator.ScreenSize
extension ScreenSizeCalculator {

    public struct ScreenSize {
        public let width: CGFloat
        public let height: CGFloat
    }
}
