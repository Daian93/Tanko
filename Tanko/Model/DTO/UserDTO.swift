//
//  UserDTO.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/1/26.
//

import Foundation

struct UsersCreate: Codable {
    let email: String
    let password: String
}

struct UserResponse: Codable, Identifiable {
    let id: UUID
    let email: String
    let isActive: Bool
    let isAdmin: Bool
    let role: String
}

extension UserResponse {
    var toDomain: User {
        User(
            id: id,
            email: email,
            isAdmin: isAdmin
        )
    }
}

struct TokenResponse: Codable {
    let token: String
}

struct JWTTokenResponse: Codable {
    let token: String
    let tokenType: String
    let expiresIn: Int
}
