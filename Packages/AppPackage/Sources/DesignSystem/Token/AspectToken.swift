//
//  AspectToken.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/16.
//

import Foundation

public enum AspectToken {
    case square
    case mainVisual
    case thumbnail

    public var value: CGFloat {
        switch self {
        case .square:
            1.0
        case .mainVisual:
            718.0 / 537.0
        case .thumbnail:
            1.0 / 1.414
        }
    }

    public var inverted: CGFloat {
        switch self {
        case .square:
            1.0
        case .mainVisual:
            537.0 / 718.0
        case .thumbnail:
            1.414 / 1.0
        }
    }
}
