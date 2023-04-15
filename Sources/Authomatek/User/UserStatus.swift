//
//  UserStatus.swift
//  authomatek-demo
//
//  Created by Tuğcan ÖNBAŞ on 12.04.2023.
//

import Fluent
import Vapor

public enum UserStatus: String, Codable {
    public static let schema: String = "autho_user_status"

    case active
    case inactive
    case deleted
}
