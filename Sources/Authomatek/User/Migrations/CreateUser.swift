//
//  CreateUser.swift
//  authomatek-demo
//
//  Created by Tuğcan ÖNBAŞ on 12.04.2023.
//

import Fluent

struct CreateUser: AsyncMigration {
    internal init() {}

    typealias FieldKeys = UserModel.FieldKeys
    let schema = UserModel.schema
    let enumSchema = UserStatus.schema

    func prepare(on database: Database) async throws {
        let statusEnum = try await database.enum(enumSchema).read()
        try await database.schema(schema)
            .id()
            .field(FieldKeys.username, .string, .required)
            .unique(on: FieldKeys.username)
            .field(FieldKeys.email, .string, .required)
            .unique(on: FieldKeys.email)
            .field(FieldKeys.passwordHash, .string, .required)
            .field(FieldKeys.userStatus, statusEnum, .required)
            .field(FieldKeys.createdAt, .string)
            .field(FieldKeys.updatedAt, .string)
            .field(FieldKeys.deletedAt, .string)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(schema).delete()
    }
}
