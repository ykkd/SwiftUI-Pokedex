//
//  PokeAPIClientWrapper.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/14.
//

import Foundation
import OpenAPIRuntime
private import OpenAPIURLSession

// MARK: - PokeAPIClientWrapperProtocol
public protocol PokeAPIClientWrapperProtocol {
    // TODO: implement
}

// MARK: - PokeAPIClientWrapper
public struct PokeAPIClientWrapper: PokeAPIClientWrapperProtocol {

    private let client: Client

    public init() throws {
        client = try Client(
            serverURL: Servers.server1(),
            transport: URLSessionTransport()
        )
    }
}
