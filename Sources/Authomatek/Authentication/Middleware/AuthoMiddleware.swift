//
//  AuthoMiddleware.swift
//  authomatek-demo
//
//  Created by Tuğcan ÖNBAŞ on 12.04.2023.
//

import Fluent
import JWT
import Vapor

public struct AuthoMiddleware: AsyncMiddleware {
    public init() {}

    public func respond(to request: Request, chainingTo next: AsyncResponder) async throws
        -> Response
    {
        guard let tokenString = request.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized, reason: "No token provided.")
        }

        let token = try request.jwt.verify(tokenString, as: AuthoPayload.self)

        guard let user = try await UserModel.getUser(from: token.subject.value, on: request.db) else {
            throw Abort(.unauthorized, reason: "User not found.")
        }

        request.auth.login(user)

        return try await next.respond(to: request)
    }
}
