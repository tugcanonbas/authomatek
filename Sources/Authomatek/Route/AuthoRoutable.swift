//
//  AuthoRoutable.swift
//  authomatek-demo
//
//  Created by Tuğcan ÖNBAŞ on 12.04.2023.
//

import Vapor

public protocol AuthoRoutable {
    var path: [PathComponent] { get }
    var register: [PathComponent] { get }
    var login: [PathComponent] { get }
    var logout: [PathComponent] { get }
    var refresh: [PathComponent] { get }
}

extension AuthoRoutable {
    var path: [PathComponent] {
        return ["auth"]
    }

    var register: [PathComponent] {
        return ["register"]
    }

    var login: [PathComponent] {
        return ["login"]
    }

    var logout: [PathComponent] {
        return ["logout"]
    }

    var refresh: [PathComponent] {
        return ["refresh"]
    }
}
