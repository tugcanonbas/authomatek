//
//  TokenService.swift
//  authomatek-demo
//
//  Created by Tuğcan ÖNBAŞ on 12.04.2023.
//

import JWT
import Vapor

public struct TokenService: AuthoTokenizer {
    public static func createToken(userID: UUID, sign: (AuthoPayload, JWKIdentifier?) throws -> String) async throws -> AuthoToken {
        let accessExpDate = Date().addingTimeInterval(Environment.get("ACCESS_EXPIRATION_DATE_INTERVAL").flatMap(Double.init) ?? (60 * 60))
        let refreshExpDate = Date().addingTimeInterval(Environment.get("REFRESH_EXPIRATION_DATE_INTERVAL").flatMap(Double.init) ?? (60 * 60 * 24 * 7))

        let accessToken = AuthoPayload(
            subject: SubjectClaim(value: userID.uuidString),
            expiration: ExpirationClaim(value: accessExpDate)
        )

        let refreshToken = AuthoPayload(
            subject: SubjectClaim(value: userID.uuidString),
            expiration: ExpirationClaim(value: refreshExpDate)
        )

        let token = try AuthoToken(
            accessToken: sign(accessToken, nil),
            refreshToken: sign(refreshToken, nil)
        )

        return token
    }

    public static func refresh(
        refreshToken: AuthoPayload, sign: (AuthoPayload, JWKIdentifier?) throws -> String
    ) async throws -> AuthoToken {
        let accessExpDate = Date().addingTimeInterval(Environment.get("ACCESS_EXPIRATION_DATE_INTERVAL").flatMap(Double.init) ?? (60 * 60))
        let refreshExpDate = Date().addingTimeInterval(Environment.get("REFRESH_EXPIRATION_DATE_INTERVAL").flatMap(Double.init) ?? (60 * 60 * 24 * 7))

        let newAccesstoken = refreshToken.copy(expiration: .init(value: accessExpDate))
        let newRefreshToken = refreshToken.copy(expiration: .init(value: refreshExpDate))

        let token = try AuthoToken(
            accessToken: sign(newAccesstoken, nil), refreshToken: sign(newRefreshToken, nil)
        )

        return token
    }
}
