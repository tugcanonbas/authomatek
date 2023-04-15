//
//  PathComponent+Extension.swift
//  authomatek-demo
//
//  Created by Tuğcan ÖNBAŞ on 14.04.2023.
//

import Vapor

extension Array where Element == PathComponent {
    func isEmpty(_ component: PathComponent) -> [Element] {
        return isEmpty ? [component] : self
    }
}
