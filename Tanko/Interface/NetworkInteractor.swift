//
//  NetworkInteractor.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/1/26.
//

import Foundation

protocol NetworkInteractor {}

extension NetworkInteractor {
    func getJSON<JSON>(_ request: URLRequest, type: JSON.Type)
        async throws(NetworkError) -> JSON where JSON: Codable {
        let (data, httpResponse) = try await URLSession.shared.getData(for: request)
        if httpResponse.statusCode == 200 {
            do {
                return try JSONDecoder().decode(type, from: data)
            } catch {
                throw NetworkError.json(error)
            }
        } else {
            throw NetworkError.status(httpResponse.statusCode)
        }
    }

    func postJSON(_ request: URLRequest, status: Int = 200) async throws(NetworkError) {
        let (_, httpResponse) = try await URLSession.shared.getData(for: request)
        if httpResponse.statusCode != status {
            throw NetworkError.status(httpResponse.statusCode)
        }
    }
    
    func postJSON<JSON>(_ request: URLRequest, type: JSON.Type)
    async throws(NetworkError) -> JSON where JSON: Codable {
        let (data, httpResponse) = try await URLSession.shared.getData(for: request)
            
        guard httpResponse.statusCode == 200 else {
            throw NetworkError.status(httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw NetworkError.json(error)
        }
    }
}
