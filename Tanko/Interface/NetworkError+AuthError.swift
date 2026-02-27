//
//  NetworkError+AuthError.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/1/26.
//

import Foundation

extension NetworkError {
    // Maps a NetworkError to its corresponding AuthError domain case.
    var asAuthError: AuthError {
        switch self {
        case .status(400): return .emailAlreadyInUse
        case .status(401): return .invalidCredentials
        case .status(409): return .emailAlreadyInUse
        case .noInternet:  return .noInternet
        case .timedOut:    return .timedOut
        case .general(let inner):
            // Unwrap recursively in case a NetworkError is wrapped inside .general
            if let nested = inner as? NetworkError {
                return nested.asAuthError
            }
            if let urlError = inner as? URLError {
                return urlError.asAuthError
            }
            return .unknown
        default: return .unknown
        }
    }
}

extension URLError {
    // Maps a URLError to its corresponding AuthError domain case.
    var asAuthError: AuthError {
        switch code {
        case .notConnectedToInternet, .networkConnectionLost: return .noInternet
        case .timedOut: return .timedOut
        default: return .unknown
        }
    }
}
