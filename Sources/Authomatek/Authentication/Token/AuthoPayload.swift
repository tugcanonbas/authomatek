//
//  AuthoPayload.swift
//  authomatek-demo
//
//  Created by Tuğcan ÖNBAŞ on 12.04.2023.
//

import JWT
import Vapor

public struct AuthoPayload: JWTPayload, Authenticatable {
    enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case expiration = "exp"
    }

    var subject: SubjectClaim
    var expiration: ExpirationClaim

    public func verify(using _: JWTSigner) throws {
        try expiration.verifyNotExpired()
    }

    func copy(expiration: ExpirationClaim) -> Self {
        return AuthoPayload(subject: subject, expiration: expiration)
    }
}
