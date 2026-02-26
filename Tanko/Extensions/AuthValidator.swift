//
//  AuthValidator.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 10/2/26.
//

import Foundation

@MainActor
struct AuthValidator {
    // Regex for validating email addresses (simplified version)
    private static let emailRegex = try! Regex(
        "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
    )

    static func isValidEmail(_ email: String) -> Bool {
        email.firstMatch(of: emailRegex) != nil
    }

    // Password validation: at least 8 characters
    static func isValidPassword(_ password: String) -> Bool {
        password.count >= 8
    }
}
