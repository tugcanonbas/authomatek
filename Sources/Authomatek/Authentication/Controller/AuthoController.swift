//
//  AuthoController.swift
//  authomatek-demo
//
//  Created by Tuğcan ÖNBAŞ on 12.04.2023.
//

import JWT
import Vapor

public struct AuthoController: AuthoControllable {
    public init() {}

    public func register(_ req: Request) async throws -> HTTPStatus {
        try await UserModel.register(req)

        return .created
    }

    public func login(_ req: Request) async throws -> AuthoToken {
        let token = try await UserModel.login(req)

        return token
    }

    public func logout(_ req: Request) throws -> HTTPStatus {
        try UserModel.logout(req)

        return .ok
    }

    public func refresh(_ req: Request) async throws -> AuthoToken {
        let newRefreshToken = try await UserModel.refresh(req)

        return newRefreshToken
    }
}
