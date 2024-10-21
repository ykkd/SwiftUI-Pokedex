//
//  AlertButtonType.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/21.
//

import SwiftUI

// MARK: - AlertButtonType
public enum AlertButtonType: Sendable, Identifiable {
    case ok(action: (@MainActor @Sendable () -> Void)?)
    case cancel(action: (@MainActor @Sendable () -> Void)?)
    case retry(action: (@MainActor @Sendable () -> Void)?)

    public var id: String {
        "AlertAction-\(title)"
    }

    public var title: String {
        switch self {
        case .ok:
            "OK"
        case .cancel:
            "Cancel"
        case .retry:
            "Retry"
        }
    }

    public var role: ButtonRole? {
        switch self {
        case .ok,
             .retry:
            nil
        case .cancel:
            .cancel
        }
    }

    public var action: (@MainActor @Sendable () -> Void)? {
        switch self {
        case let .ok(action),
             let .cancel(action),
             let .retry(action):
            action
        }
    }
}

// MARK: Equatable
extension AlertButtonType: Equatable {

    public static func == (lhs: AlertButtonType, rhs: AlertButtonType) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: Hashable
extension AlertButtonType: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
