//
//  Array+.swift
//  SwiftUI-Pokedex
//
//  Created by ykkd on 2024/10/18.
//

import Foundation

extension Array {

    public func chunked(into size: Int) -> [[Element]] {
        var chunks: [[Element]] = []
        var currentIndex = 0
        while currentIndex < count {
            let endIndex = Swift.min(currentIndex + size, count)
            chunks.append(Array(self[currentIndex ..< endIndex]))
            currentIndex = endIndex
        }
        return chunks
    }
}
