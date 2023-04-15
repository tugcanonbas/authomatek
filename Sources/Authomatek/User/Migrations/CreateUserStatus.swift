//
//  CreateUserStatus.swift
//  authomatek-demo
//
//  Created by Tuğcan ÖNBAŞ on 12.04.2023.
//

import Fluent

struct CreateUserStatus: AsyncMigration {
    internal init() {}

    let schema = UserStatus.schema

    func prepare(on database: Database) async throws {
        _ = try await database.enum(schema)
            .case(UserStatus.active.rawValue)
            .case(UserStatus.inactive.rawValue)
            .case(UserStatus.deleted.rawValue)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.enum(schema).delete()
    }
}
