//
//  AuthError.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 9/2/26.
//

import Foundation
import SwiftUI

enum AuthError: LocalizedError {
    case invalidCredentials
    case emailAlreadyInUse
    case sessionExpired
    case noInternet
    case timedOut
    case unknown

    var localizedKey: LocalizedStringKey {
        switch self {
        case .invalidCredentials: "auth.error.invalid_credentials"
        case .emailAlreadyInUse: "auth.error.email_exists"
        case .sessionExpired: "auth.error.session_expired"
        case .noInternet: "auth.error.no_internet"
        case .timedOut: "auth.error.timed_out"
        case .unknown: "auth.error.unknown"
        }
    }

    var errorDescription: String? {
        switch self {
        case .invalidCredentials: String(localized: "auth.error.invalid_credentials")
        case .emailAlreadyInUse: String(localized: "auth.error.email_exists")
        case .sessionExpired: String(localized: "auth.error.session_expired")
        case .noInternet: String(localized: "auth.error.no_internet")
        case .timedOut: String(localized: "auth.error.timed_out")
        case .unknown: String(localized: "auth.error.unknown")
        }
    }
}
