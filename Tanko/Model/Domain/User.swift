//
//  User.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/1/26.
//

import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    let email: String
    let isAdmin: Bool
}

extension User {
    var displayName: String {
        email.components(separatedBy: "@").first?.capitalized ?? email
    }
}
