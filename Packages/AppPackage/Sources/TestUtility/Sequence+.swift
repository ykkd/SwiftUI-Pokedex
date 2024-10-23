//
//  Sequence+.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/24.
//

import Foundation

extension Sequence {

    @discardableResult
    public func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }
}
