//
//  UserModel+DTO.swift
//  authomatek-demo
//
//  Created by Tuğcan ÖNBAŞ on 12.04.2023.
//

import Vapor

public extension UserModel {
    enum DTO {
        public struct User: Content {
            let id: UUID
            let email: String
            let username: String
            let status: UserStatus
            let createdAt: Date
            let updatedAt: Date
            let deletedAt: Date?
        }

        public struct Users: Content {
            let count: Int
            let users: [User]

            init(users: [User]) {
                count = users.count
                self.users = users
            }
        }

        public struct Register: Content, Validatable {
            let email: String
            let username: String
            let password: String

            public static func validations(_ validations: inout Validations) {
                UserModel.validators(&validations)
            }
        }

        public struct Login: Content, Validatable {
            let email: String?
            let username: String?
            let password: String

            public init(email: String? = nil, username: String? = nil, password: String) {
                self.email = email
                self.username = username
                self.password = password
            }

            public static func validations(_ validations: inout Validations) {
                UserModel.validators(&validations)
            }
        }
    }
}

public extension UserModel {
    func toDTO() -> DTO.User {
        return DTO.User(
            id: id!,
            email: email,
            username: username,
            status: status,
            createdAt: createdAt!,
            updatedAt: updatedAt!,
            deletedAt: deletedAt
        )
    }

    static func toDTO(users: [UserModel]) -> DTO.Users {
        return DTO.Users(users: users.map { $0.toDTO() })
    }
}
