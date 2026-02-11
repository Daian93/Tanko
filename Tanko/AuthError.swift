//
//  AuthError.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 9/2/26.
//

import Foundation

enum AuthError: LocalizedError {
    case invalidCredentials
    case emailAlreadyExists
    case sessionExpired
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            String(localized: "auth.error.invalid_credentials")
        case .emailAlreadyExists:
            String(localized: "auth.error.email_exists")
        case .sessionExpired:
            String(localized: "auth.error.session_expired")
        case .unknown:
            String(localized: "auth.error.unknown")
        }
    }
}
