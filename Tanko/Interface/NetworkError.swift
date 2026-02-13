//
//  NetworkError.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/1/26.
//

import Foundation

enum NetworkError: LocalizedError {
    case general(Error)
    case status(Int)
    case json(Error)
    case invalidData
    case nonHTTPResponse
    case unauthorized
    case cancelled
    case noInternet
    case timedOut
    case invalidJSON

    var errorDescription: String? {
        switch self {
        case .general(let error):
            error.localizedDescription
        case .status(let code):
            "HTTP status code: \(code)"
        case .json(let error):
            "JSON error: \(error)"
        case .invalidData:
            "Invalid data received from server"
        case .nonHTTPResponse:
            "URLSession did not return an HTTP response"
        case .unauthorized:
            "No valid authorization token available"
        case .cancelled:
            "The request was cancelled"
        case .noInternet:
            "No internet connection available"
        case .timedOut:
            "The request timed out"
        case .invalidJSON:
            "Server returned invalid JSON"
        }
    }
}
