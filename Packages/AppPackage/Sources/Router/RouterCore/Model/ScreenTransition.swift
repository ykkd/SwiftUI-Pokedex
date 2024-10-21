//
//  ScreenTransition.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/14.
//

import Entity
import Foundation

public enum ScreenTransition {
    case push
    case sheet
    case fullScreen
    case alert

    public var withNavigation: Bool {
        switch self {
        case .push,
             .alert:
            false
        case .sheet,
             .fullScreen:
            true
        }
    }

    public var naviBarLeadingButtonType: ToolbarButtonType? {
        switch self {
        case .push:
            .back
        case .fullScreen:
            .close
        case .alert,
             .sheet:
            nil
        }
    }
}
