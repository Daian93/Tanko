//
//  URLRequest+Auth.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/1/26.
//

import Foundation

extension URLRequest {

    static func get(url: URL, bearerToken: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        return request
    }

    static func post<JSON: Codable>(
        url: URL,
        body: JSON,
        bearerToken: String,
        method: String = "POST"
    ) -> URLRequest {
        var request = URLRequest.post(url: url, body: body, method: method)
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    static func post(
        url: URL,
        bearerToken: String,
        method: String = "POST"
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.timeoutInterval = 60
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        return request
    }

    static func delete(url: URL, bearerToken: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.timeoutInterval = 60
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
