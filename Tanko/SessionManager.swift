//
//  SessionManager.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 8/2/26.
//

import Foundation

@MainActor
@Observable
final class SessionManager {
    private let network: NetworkRepository
    private(set) var user: User?
    private(set) var token: String?
    
    var isGuest: Bool = false

    var isAuthenticated: Bool { token != nil }
    var canAccessApp: Bool { isAuthenticated || isGuest }

    init(network: NetworkRepository = Network()) {
        self.network = network
        restoreSession()
    }

    func restoreSession() {
        if let savedToken = KeychainService.load(key: SessionKeys.jwtToken) {
            self.token = savedToken
            Task {
                await loadCurrentUser()
            }
        }
    }

    func login(email: String, password: String) async throws {
        let newToken = try await network.login(email: email, password: password)
        
        self.token = newToken
        self.isGuest = false
        
        KeychainService.save(newToken, key: SessionKeys.jwtToken)

        await loadCurrentUser()
    }

    func loadCurrentUser() async {
        guard let token = self.token else { return }
        
        do {
            let request = URLRequest.get(url: .jwtMe, bearerToken: token)
            let response: UserResponse = try await network.getJSON(request, type: UserResponse.self)
            self.user = response.toDomain
        }
    }

    func register(email: String, password: String) async throws {
        try await network.createUser(email: email, password: password)
    }

    func continueAsGuest() {
        self.isGuest = true
        self.token = nil
        self.user = nil
        print("DEBUG: Modo invitado activado. canAccessApp: \(canAccessApp)")
    }

    func logout() {
        self.user = nil
        self.token = nil
        self.isGuest = false
        KeychainService.delete(key: SessionKeys.jwtToken)
    }
}
