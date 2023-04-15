//
//  AuthoControllable.swift
//  authomatek-demo
//
//  Created by Tuğcan ÖNBAŞ on 12.04.2023.
//

import Vapor

public protocol AuthoControllable {
    associatedtype RegisterModel: AsyncResponseEncodable
    associatedtype LoginModel: AsyncResponseEncodable
    associatedtype LogoutModel: AsyncResponseEncodable
    associatedtype RefreshModel: AsyncResponseEncodable

    func register(_ req: Request) async throws -> RegisterModel
    func login(_ req: Request) async throws -> LoginModel
    func logout(_ req: Request) async throws -> LogoutModel
    func refresh(_ req: Request) async throws -> RefreshModel
}
