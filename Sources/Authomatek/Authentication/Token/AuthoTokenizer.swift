//
//  AuthoTokenizer.swift
//  authomatek-demo
//
//  Created by Tuğcan ÖNBAŞ on 12.04.2023.
//

import JWT
import Vapor

public protocol AuthoTokenizer {
    associatedtype P: JWTPayload
    static func createToken(userID: UUID, sign: (P, JWKIdentifier?) throws -> String) async throws -> AuthoToken
}
