//
//  ApplicationError.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/14.
//

import Foundation

// MARK: - ApplicationError
public enum ApplicationError: Error {
    case network(NetworkError)
}

// MARK: ApplicationError.NetworkError
extension ApplicationError {

    public enum NetworkError: Error {
        case api(Error)
        case invalidResponse
    }
}
