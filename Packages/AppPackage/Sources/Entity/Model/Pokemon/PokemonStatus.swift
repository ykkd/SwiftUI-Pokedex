//
//  PokemonStatus.swift
//  AppPackage
//
//  Created by ykkd on 2024/10/17.
//

import Foundation

// MARK: - PokemonStatus
public struct PokemonStatus: Sendable, Identifiable, Hashable {

    public var id: UUID {
        .init()
    }

    public let type: `Type`

    public let value: Int

    public init?(name: String, value: Int) {
        guard let type = Type(rawValue: name) else {
            return nil
        }
        self.type = type
        self.value = value
    }
}

// MARK: PokemonStatus.`Type`
extension PokemonStatus {

    public enum `Type`: String, Sendable {
        case hp
        case attack
        case defense
        case specialAttack
        case specialDefense
        case speed

        public init?(rawValue: String) {
            switch rawValue {
            case "hp":
                self = .hp
            case "attack":
                self = .attack
            case "defense":
                self = .defense
            case "special-attack":
                self = .specialAttack
            case "special-defense":
                self = .specialDefense
            case "speed":
                self = .speed
            default:
                return nil
            }
        }

        public var priority: Int {
            switch self {
            case .hp:
                0
            case .attack:
                1
            case .defense:
                2
            case .specialAttack:
                3
            case .specialDefense:
                4
            case .speed:
                5
            }
        }
    }
}
