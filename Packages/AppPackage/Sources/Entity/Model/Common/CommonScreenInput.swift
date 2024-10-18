//
//  CommonScreenInput.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/14.
//

import Foundation

public struct CommonScreenInput {

    public let withNavigation: Bool

    public let naviBarLeadingButtonType: NaviBarButtonType?

    public init(
        withNavigation: Bool,
        naviBarLeadingButtonType: NaviBarButtonType?
    ) {
        self.withNavigation = withNavigation
        self.naviBarLeadingButtonType = naviBarLeadingButtonType
    }
}
