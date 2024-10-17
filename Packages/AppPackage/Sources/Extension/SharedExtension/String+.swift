//
//  String+.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/17.
//

import Foundation

extension String {

    public func initialLetterUppercased() -> Self {
        prefix(1).uppercased() + dropFirst()
    }
}
