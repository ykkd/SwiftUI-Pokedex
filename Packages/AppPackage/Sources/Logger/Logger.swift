//
//  Logger.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/14.
//

import Dependencies
import Foundation
private import os.log

// MARK: - MainLogger
public struct MainLogger: Sendable {

    private let logger: Logger

    public init() {
        logger = Logger(subsystem: "SwiftUI-Pokedex", category: "Main")
    }
}

// MARK: - Interface
extension MainLogger {

    public func log(
        _ level: LogLevel,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        message: String
    ) {
        logger.log(
            level: level.oslogType,
            "\(level.oslogType.emoji) file:\(file) line:\(line) func:\(function) \(message)"
        )
    }
}

// MARK: DependencyKey
extension MainLogger: DependencyKey {

    public static var liveValue: Self {
        .init()
    }
}

extension DependencyValues {

    public var mainLogger: MainLogger {
        get { self[MainLogger.self] }
        set { self[MainLogger.self] = newValue }
    }
}

// MARK: - MainLogger.LogLevel
extension MainLogger {

    public enum LogLevel {
        case debug
        case info
        case error
        case fault

        fileprivate var oslogType: OSLogType {
            switch self {
            case .debug:
                .debug
            case .info:
                .info
            case .error:
                .error
            case .fault:
                .fault
            }
        }
    }
}

extension OSLogType {

    fileprivate var emoji: String {
        switch self {
        case .debug:
            "💚" // green
        case .info:
            "💙" // blue
        case .error,
             .fault:
            "❤️" // red
        default:
            "💛" // yellow
        }
    }
}
