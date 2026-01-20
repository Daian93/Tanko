//
//  URL+Users.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/1/26.
//

import Foundation

extension URL {
    static let login = api.appending(path: "users/login")

    static let renew = api.appending(path: "users/renew")

    static let createUser = api.appending(path: "users")

    static let jwtLogin = api.appending(path: "users/jwt/login")

    static let jwtRefresh = api.appending(path: "users/jwt/refresh")

    static let jwtMe = api.appending(path: "users/jwt/me")
}
