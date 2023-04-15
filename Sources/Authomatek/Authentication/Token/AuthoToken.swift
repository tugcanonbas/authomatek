//
//  AuthoToken.swift
//  authomatek-demo
//
//  Created by Tuğcan ÖNBAŞ on 12.04.2023.
//

import Vapor

public struct AuthoToken: AuthoTokenable {
    public let accessToken: String
    public let refreshToken: String

    public init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

extension AuthoToken: Content {}
