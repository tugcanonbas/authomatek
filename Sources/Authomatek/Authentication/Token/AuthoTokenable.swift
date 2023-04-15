//
//  AuthoTokenable.swift
//  authomatek-demo
//
//  Created by Tuğcan ÖNBAŞ on 14.04.2023.
//

import Foundation

public protocol AuthoTokenable {
    var accessToken: String { get }
    var refreshToken: String { get }
}
