//
//  UserModel+Authenticatable.swift
//  authomatek-demo
//
//  Created by Tuğcan ÖNBAŞ on 12.04.2023.
//

import Vapor

extension UserModel: Authenticatable {
    static let emailKey: KeyPath<UserModel, Field<String>> = \.$email
    static let usernameKey: KeyPath<UserModel, Field<String>> = \.$username
    static let passwordHashKey: KeyPath<UserModel, Field<String>> = \.$passwordHash

    func verify(_ password: String) throws -> Bool {
        try Bcrypt.verify(password, created: passwordHash)
    }
}

extension UserModel {
    enum ValidationKeys {
        static let email: ValidationKey = "email"
        static let username: ValidationKey = "username"
        static let password: ValidationKey = "password"
    }

    static func validators(_ validations: inout Validations) {
        let usernameValidators: Validator<String> = .count(3...) && .alphanumeric && .pattern(#"^[a-zA-Z0-9-_.]*$"#)

        validations.add(ValidationKeys.email, as: String.self, is: .email, required: false)
        validations.add(ValidationKeys.username, as: String.self, is: usernameValidators, required: false)
        validations.add(ValidationKeys.password, as: String.self, is: .count(8...), required: true)
    }
}

public extension UserModel {
    static func register(_ req: Request) async throws {
        try UserModel.DTO.Register.validate(content: req)
        let register = try req.content.decode(UserModel.DTO.Register.self)

        guard try await UserModel.getUser(with: register.email, or: register.username, on: req.db) == nil else {
            throw Abort(.badRequest, reason: "User already exists")
        }

        try await UserModel.create(with: register, on: req.db)
    }

    static func login(_ req: Request, completion: (() -> Void)? = nil) async throws -> AuthoToken {
        try UserModel.DTO.Login.validate(content: req)
        let login = try req.content.decode(UserModel.DTO.Login.self)

        guard let _ = login.email ?? login.username else {
            throw Abort(.badRequest, reason: "Email or username is required")
        }

        guard let dbUser = try await UserModel.getUser(with: login.email ?? "", or: login.username ?? "", on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }

        guard try dbUser.verify(login.password) else {
            throw Abort(.badRequest, reason: "Password is incorrect")
        }

        let token = try await TokenService.createToken(userID: dbUser.requireID(), sign: req.jwt.sign)

        completion?() ?? req.auth.login(dbUser)

        return token
    }

    static func logout(_ req: Request, completion: (() -> Void)? = nil) throws {
        completion?() ?? req.auth.logout(UserModel.self)
    }

    static func refresh(_ req: Request, completion: (() -> Void)? = nil) async throws -> AuthoToken {
        guard let token = req.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized, reason: "No token provided.")
        }

        let refreshToken = try req.jwt.verify(token, as: AuthoPayload.self)

        guard let dbUser = try await UserModel.getUser(from: refreshToken.subject.value, on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }

        let newRefreshToken = try await TokenService.refresh(refreshToken: refreshToken, sign: req.jwt.sign)

        completion?() ?? req.auth.login(dbUser)

        return newRefreshToken
    }
}
