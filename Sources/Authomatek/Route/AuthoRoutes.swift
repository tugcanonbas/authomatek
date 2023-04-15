//
//  AuthoRoutes.swift
//  authomatek-demo
//
//  Created by Tuğcan ÖNBAŞ on 12.04.2023.
//

import Vapor

struct AuthoRoutes<Controller: AuthoControllable>: RouteCollection {
    let controller: Controller
    let config: AuthoRoutable

    init(controller: Controller, config: AuthoRoutable) {
        self.controller = controller
        self.config = config
    }

    func boot(routes: RoutesBuilder) throws {
        let authoRoutes = routes.grouped(config.path)

        authoRoutes.post(config.register, use: controller.register)
        authoRoutes.post(config.login, use: controller.login)

        let protected = authoRoutes.grouped(AuthoMiddleware())

        protected.get(config.logout, use: controller.logout)
        protected.get(config.refresh, use: controller.refresh)
    }
}
