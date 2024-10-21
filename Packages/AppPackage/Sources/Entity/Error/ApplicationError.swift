//
//  ApplicationError.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/14.
//

import Foundation

// MARK: - ApplicationError
public enum ApplicationError: Error, Equatable, Hashable {
    case network(NetworkError)
    case database(DatabaseError)
}

// MARK: LocalizedError
extension ApplicationError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case let .network(error as LocalizedError),
             let .database(error as LocalizedError):
            error.errorDescription
        }
    }

    public var failureReason: String? {
        switch self {
        case let .network(error as LocalizedError),
             let .database(error as LocalizedError):
            error.failureReason
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case let .network(error as LocalizedError),
             let .database(error as LocalizedError):
            error.recoverySuggestion
        }
    }

    public var helpAnchor: String? {
        switch self {
        case let .network(error as LocalizedError),
             let .database(error as LocalizedError):
            error.helpAnchor
        }
    }

    public var alertMessage: String {
        var text = ""

        if let failureReason {
            text = "\(failureReason)"
        }

        if let recoverySuggestion {
            if !text.isEmpty {
                text += "\n\(recoverySuggestion)"
            } else {
                text = recoverySuggestion
            }
        }
        return text
    }
}

// MARK: ApplicationError.NetworkError
extension ApplicationError {

    public enum NetworkError: Error {
        case api(Error)
        case invalidResponse
    }
}

// MARK: - ApplicationError.NetworkError + Equatable
extension ApplicationError.NetworkError: Equatable {

    public static func == (
        lhs: ApplicationError.NetworkError,
        rhs: ApplicationError.NetworkError
    ) -> Bool {
        switch (lhs, rhs) {
        case let (.api(lhsError), .api(rhsError)):
            let lhsNsError: NSError = lhsError as NSError
            let rhsNsError: NSError = rhsError as NSError
            return lhsNsError.code == rhsNsError.code
        case (.invalidResponse, .invalidResponse):
            return true
        case (_, _):
            return false
        }
    }
}

// MARK: - ApplicationError.NetworkError + Hashable
extension ApplicationError.NetworkError: Hashable {

    public func hash(into hasher: inout Hasher) {
        switch self {
        case let .api(error):
            let nsError: NSError = error as NSError
            hasher.combine(nsError.domain)
            hasher.combine(nsError.code)
        case .invalidResponse:
            hasher.combine("invalidResponse")
        }
    }
}

// MARK: - ApplicationError.NetworkError + LocalizedError
extension ApplicationError.NetworkError: LocalizedError {

    public var errorDescription: String? {
        "通信エラー"
    }

    public var failureReason: String? {
        switch self {
        case let .api(error):
            let nsError: NSError = error as NSError
            return "(\(nsError.code))通信に失敗しました。"
        case .invalidResponse:
            return "データ不整合が発生しました。"
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .api:
            "時間をおいて再度お試しください。"
        case .invalidResponse:
            "お問い合わせください。"
        }
    }

    public var helpAnchor: String? {
        switch self {
        case .api:
            nil
        case .invalidResponse:
            "https://www.apple.com/" // fake url. this is just for an example
        }
    }
}

// MARK: - ApplicationError.DatabaseError
extension ApplicationError {

    public enum DatabaseError: Error {
        case write(any Error)
        case read(any Error)
    }
}

// MARK: - ApplicationError.DatabaseError + Equatable
extension ApplicationError.DatabaseError: Equatable {

    public static func == (
        lhs: ApplicationError.DatabaseError,
        rhs: ApplicationError.DatabaseError
    ) -> Bool {
        switch (lhs, rhs) {
        case let (.write(lhsError), .write(rhsError)),
             let (.read(lhsError), .read(rhsError)):
            let lhsNsError: NSError = lhsError as NSError
            let rhsNsError: NSError = rhsError as NSError
            return lhsNsError.code == rhsNsError.code
        case (_, _):
            return false
        }
    }
}

// MARK: - ApplicationError.DatabaseError + Hashable
extension ApplicationError.DatabaseError: Hashable {

    public func hash(into hasher: inout Hasher) {
        switch self {
        case let .write(error),
             let .read(error):
            let nsError: NSError = error as NSError
            hasher.combine(nsError.domain)
            hasher.combine(nsError.code)
        }
    }
}

// MARK: - ApplicationError.DatabaseError + LocalizedError
extension ApplicationError.DatabaseError: LocalizedError {

    public var errorDescription: String? {
        "データベースエラー"
    }

    public var failureReason: String? {
        switch self {
        case let .write(error):
            let nsError: NSError = error as NSError
            return "(\(nsError.code))データベース書き込みに失敗しました。"
        case let .read(error):
            let nsError: NSError = error as NSError
            return "(\(nsError.code))データベース読み取りに失敗しました。"
        }
    }

    public var recoverySuggestion: String? {
        "時間をおいて再度お試しください。再インストールによって解消される場合があります"
    }
}
