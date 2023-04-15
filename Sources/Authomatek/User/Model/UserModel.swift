//
//  UserModel.swift
//  authomatek-demo
//
//  Created by Tuğcan ÖNBAŞ on 12.04.2023.
//

import Fluent
import Vapor

public final class UserModel: User, Model {
    public static let schema: String = "autho_users"

    enum FieldKeys {
        static let email: FieldKey = "email"
        static let username: FieldKey = "username"
        static let passwordHash: FieldKey = "password_hash"
        static let userStatus: FieldKey = "user_status"
        static let createdAt: FieldKey = "created_at"
        static let updatedAt: FieldKey = "updated_at"
        static let deletedAt: FieldKey = "deleted_at"
    }

    @ID(key: .id)
    public var id: UUID?

    @Field(key: FieldKeys.email)
    public var email: String

    @Field(key: FieldKeys.username)
    public var username: String

    @Field(key: FieldKeys.passwordHash)
    public var passwordHash: String

    @Enum(key: FieldKeys.userStatus)
    public var status: UserStatus

    @Timestamp(key: FieldKeys.createdAt, on: .create, format: .iso8601)
    public var createdAt: Date?

    @Timestamp(key: FieldKeys.updatedAt, on: .update, format: .iso8601)
    public var updatedAt: Date?

    @Timestamp(key: FieldKeys.deletedAt, on: .delete, format: .iso8601)
    public var deletedAt: Date?

    public init() {}

    public init(
        id: UUID? = nil,
        email: String,
        username: String,
        passwordHash: String,
        status: UserStatus
    ) {
        self.id = id
        self.email = email
        self.username = username
        self.passwordHash = passwordHash
        self.status = status
    }
}
