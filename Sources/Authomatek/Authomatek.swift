//
//  Authomatek.swift
//  authomatek-demo
//
//  Created by Tuğcan ÖNBAŞ on 12.04.2023.
//

import JWT
import Vapor

public struct Authomatek<Configuration: AuthoRoutable, Controller: AuthoControllable> {
    public static func configure(_ app: Application, configuration: Configuration = RouteConfig(), controller: Controller = AuthoController()) throws {
        app.migrations.add([
            CreateUserStatus(),
            CreateUser(),
        ])

        let controller = AuthoRoutes(controller: controller, config: configuration)
        try app.routes.register(collection: controller)

        try configureJWT(app)
    }

    private static func configureJWT(_ app: Application) throws {
        guard let environmentFilePath = Environment.get("SECRET_KEY_FILE_PATH") else {
            throw Abort(.internalServerError, reason: ".pem file name is not set.")
        }

        let secretKeyFile = try String(contentsOfFile: environmentFilePath)

        try app.jwt.signers.use(.rs256(key: .private(pem: secretKeyFile)))
    }
}
