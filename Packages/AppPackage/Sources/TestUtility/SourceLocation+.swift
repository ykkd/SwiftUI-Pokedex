//
//  SourceLocation+.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/23.
//

import Foundation
import Testing

extension SourceLocation {

    public static func generate(
        fileID: String = #fileID,
        filePath: String = #filePath,
        line: Int = #line,
        column: Int = #column
    ) -> Self {
        self.init(
            fileID: fileID,
            filePath: filePath,
            line: line,
            column: column
        )
    }
}
