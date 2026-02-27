//
//  URLSession.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/1/26.
//

import Foundation

extension URLSession {
    func getData(for request: URLRequest) async throws(NetworkError) -> (
        data: Data, response: HTTPURLResponse
    ) {
        do {
            let (data, response) = try await URLSession.shared.data(
                for: request
            )
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.nonHTTPResponse
            }
            return (data, httpResponse)
        } catch let networkError as NetworkError {
            throw networkError
        } catch let urlError as URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                throw NetworkError.noInternet
            case .timedOut:
                throw NetworkError.timedOut
            case .cancelled:
                throw NetworkError.cancelled
            default:
                throw NetworkError.general(urlError)
            }
        } catch {
            throw NetworkError.general(error)
        }
    }
}
