//
//  CommonScreenInput.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/14.
//

import Foundation

public struct CommonScreenInput {

    public let withNavigation: Bool

    public let naviBarLeadingButtonType: ToolbarButtonType?

    public init(
        withNavigation: Bool,
        naviBarLeadingButtonType: ToolbarButtonType?
    ) {
        self.withNavigation = withNavigation
        self.naviBarLeadingButtonType = naviBarLeadingButtonType
    }
}
