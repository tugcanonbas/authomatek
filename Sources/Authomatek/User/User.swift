//
//  User.swift
//  authomatek-demo
//
//  Created by Tuğcan ÖNBAŞ on 12.04.2023.
//

import Foundation

protocol User {
    var id: UUID? { get }
    var email: String { get }
    var username: String { get }
    var passwordHash: String { get }
    var status: UserStatus { get }
    var createdAt: Date? { get }
    var updatedAt: Date? { get }
    var deletedAt: Date? { get }
}
