//
//  RouteConfig.swift
//  authomatek-demo
//
//  Created by Tuğcan ÖNBAŞ on 12.04.2023.
//

import Vapor

public struct RouteConfig: AuthoRoutable {
    public let path: [PathComponent]
    public let register: [PathComponent]
    public let login: [PathComponent]
    public let logout: [PathComponent]
    public let refresh: [PathComponent]

    public init(path: PathComponent..., register: PathComponent..., login: PathComponent..., logout: PathComponent..., refresh: PathComponent...) {
        self.path = path.isEmpty("auth")
        self.register = register.isEmpty("register")
        self.login = login.isEmpty("login")
        self.logout = logout.isEmpty("logout")
        self.refresh = refresh.isEmpty("refresh")
    }
}
