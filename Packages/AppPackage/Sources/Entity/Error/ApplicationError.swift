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
    case database(DatabaseError)
}

// MARK: ApplicationError.NetworkError
extension ApplicationError {

    public enum NetworkError: Error {
        case api(Error)
        case invalidResponse
    }
}

// MARK: ApplicationError.DatabaseError
extension ApplicationError {

    public enum DatabaseError: Error {
        case write(any Error)
        case read(any Error)
    }
}
