//
//  MainLoggerContainer.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/14.
//

import Dependencies
import Foundation
import os.log

// MARK: - MainLoggerContainer
public struct MainLoggerContainer: Sendable {

    private var logger: Logger

    public init() {
        logger = Logger(subsystem: "SwiftUI-Pokedex", category: "Main")
    }
}

// MARK: - Interface
extension MainLoggerContainer {

    public func log(
        _ level: OSLogType,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        message: String
    ) {
        logger.log(
            level: level,
            "\(level.emoji) file:\(file) line:\(line) func:\(function) \(message)"
        )
    }
}

// MARK: TestDependencyKey
extension MainLoggerContainer: TestDependencyKey {

    public static var testValue: Self {
        .init()
    }

    public static var previewValue: Self {
        .init()
    }
}

extension DependencyValues {

    public var mainLoggerContainer: MainLoggerContainer {
        get { self[MainLoggerContainer.self] }
        set { self[MainLoggerContainer.self] = newValue }
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
