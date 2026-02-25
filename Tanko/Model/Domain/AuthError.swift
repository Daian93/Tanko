//
//  AuthError.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 9/2/26.
//

import Foundation

enum AuthError: LocalizedError {
    case invalidCredentials
    case emailAlreadyInUse
    case sessionExpired
    case noInternet
    case timedOut
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            String(localized: "auth.error.invalid_credentials")
        case .emailAlreadyInUse:
            String(localized: "auth.error.email_exists")
        case .sessionExpired:
            String(localized: "auth.error.session_expired")
        case .noInternet:
            String(localized: "auth.error.no_internet")
        case .timedOut:
            String(localized: "auth.error.timed_out")
        case .unknown:
            String(localized: "auth.error.unknown")
        }
    }
}
