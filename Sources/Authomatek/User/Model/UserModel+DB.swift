//
//  UserModel+DB.swift
//  authomatek-demo
//
//  Created by Tuğcan ÖNBAŞ on 12.04.2023.
//

import Fluent
import Vapor

public extension UserModel {
    static func getUser(with email: String, or username: String, on database: Database) async throws -> UserModel? {
        try await UserModel.query(on: database).group(.or) { group in
            group
                .filter(\.$email == email)
                .filter(\.$username == username)
        }.first()
    }

    static func getUser(with id: UUID, on database: Database) async throws -> UserModel? {
        try await UserModel.query(on: database).filter(\.$id == id).first()
    }

    static func getUser(from token: String, on database: Database) async throws -> UserModel? {
        guard let id = UUID(uuidString: token) else {
            throw Abort(.notFound, reason: "User not found.")
        }

        return try await UserModel.getUser(with: id, on: database)
    }

    static func create(with register: DTO.Register, on database: Database) async throws {
        let passwordHash = try Bcrypt.hash(register.password)
        let user = UserModel(email: register.email, username: register.username, passwordHash: passwordHash, status: .active)

        try await user.save(on: database)
    }
}
