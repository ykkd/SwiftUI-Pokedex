//
//  TypographyToken.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/16.
//

import SwiftUI

// MARK: - TypographyToken
public enum TypographyToken {
    case titleOneRegular
    case titleOneBold
    case titleTwoRegular
    case titleTwoBold
    case titleThreeRegular
    case titleThreeBold
    case headlineSemibold
    case subheadlineRegular
    case subheadlineSemibold
    case bodyRegular
    case bodySemibold
    case captionOneRegular
    case captionOneMedium
    case captionTwoRegular
    case captionTwoSemibold

    public var swiftUIFont: Font {
        Font.custom(fontName, size: fontSize)
            .weight(weight)
    }

    public var uiFont: UIFont {
        UIFont.systemFont(ofSize: fontSize, weight: uiKitWeight)
    }

    public var lineHeight: CGFloat {
        switch self {
        case .titleOneRegular,
             .titleOneBold:
            34
        case .titleTwoRegular,
             .titleTwoBold:
            28
        case .titleThreeRegular,
             .titleThreeBold:
            25
        case .headlineSemibold,
             .bodyRegular,
             .bodySemibold:
            22
        case .subheadlineRegular,
             .subheadlineSemibold:
            20
        case .captionOneRegular,
             .captionOneMedium:
            16
        case .captionTwoRegular,
             .captionTwoSemibold:
            13
        }
    }
}

extension TypographyToken {

    private var fontName: String {
        switch self {
        case .titleOneRegular,
             .titleOneBold,
             .titleTwoRegular,
             .titleTwoBold,
             .titleThreeRegular,
             .titleThreeBold,
             .headlineSemibold,
             .subheadlineRegular,
             .subheadlineSemibold,
             .bodyRegular,
             .bodySemibold,
             .captionOneRegular,
             .captionOneMedium,
             .captionTwoRegular,
             .captionTwoSemibold:
            "SF Pro"
        }
    }

    private var weight: Font.Weight {
        switch self {
        case .titleOneRegular,
             .titleTwoRegular,
             .titleThreeRegular,
             .subheadlineRegular,
             .bodyRegular,
             .captionOneRegular,
             .captionTwoRegular:
            .regular
        case .titleOneBold,
             .titleTwoBold,
             .titleThreeBold:
            .bold
        case .headlineSemibold,
             .subheadlineSemibold,
             .bodySemibold,
             .captionTwoSemibold:
            .semibold
        case .captionOneMedium:
            .medium
        }
    }

    private var uiKitWeight: UIFont.Weight {
        switch self {
        case .titleOneRegular,
             .titleTwoRegular,
             .titleThreeRegular,
             .subheadlineRegular,
             .bodyRegular,
             .captionOneRegular,
             .captionTwoRegular:
            .regular
        case .titleOneBold,
             .titleTwoBold,
             .titleThreeBold:
            .bold
        case .headlineSemibold,
             .subheadlineSemibold,
             .bodySemibold,
             .captionTwoSemibold:
            .semibold
        case .captionOneMedium:
            .medium
        }
    }

    private var fontSize: CGFloat {
        switch self {
        case .titleOneRegular,
             .titleOneBold:
            28
        case .titleTwoRegular,
             .titleTwoBold:
            22
        case .titleThreeRegular,
             .titleThreeBold:
            20
        case .headlineSemibold,
             .bodyRegular,
             .bodySemibold:
            17
        case .subheadlineRegular,
             .subheadlineSemibold:
            15
        case .captionOneRegular,
             .captionOneMedium:
            12
        case .captionTwoRegular,
             .captionTwoSemibold:
            11
        }
    }
}
