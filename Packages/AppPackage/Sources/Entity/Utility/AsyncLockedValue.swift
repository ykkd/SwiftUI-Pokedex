//
//  AsyncLockedValue.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/23.
//

import Foundation

public final actor AsyncLockedValue<T> {
    private var value: T

    public init(initialValue: @autoclosure @Sendable () -> T) {
        value = initialValue()
    }

    public func use(_ action: @Sendable (T) -> Void) {
        action(value)
    }

    public func mutate(_ mutation: @Sendable (inout T) -> Void) {
        mutation(&value)
    }

    public func set(_ value: T) {
        self.value = value
    }

    public func get() -> T {
        value
    }
}
