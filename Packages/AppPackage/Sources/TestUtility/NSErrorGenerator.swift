//
//  NSErrorGenerator.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/24.
//

import Foundation

public enum NSErrorGenerator {

    public static func generate(domain: String, code: Int) -> NSError {
        .init(domain: domain, code: code)
    }
}
