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
    var didLogout: Bool = false

    var isAuthenticated: Bool { token != nil }
    var canAccessApp: Bool { isAuthenticated || isGuest }

    init(network: NetworkRepository = Network()) {
        self.network = network
        // Restore token synchronously (no Task, no state mutation during render)
        if let savedToken = KeychainService.load(key: SessionKeys.jwtToken) {
            self.token = savedToken
        }
    }

    func restoreSession() async {
        // Token is already restored in init synchronously.
        // Here we just load the user profile if authenticated.
        guard token != nil else { return }
        await loadCurrentUser()
    }

    func login(
        email: String,
        password: String,
        onCompletion: (() async -> Void)? = nil
    ) async throws(NetworkError) {
        let jwt = try await network.login(email: email, password: password)

        self.token = jwt
        self.isGuest = false
        KeychainService.save(jwt, key: SessionKeys.jwtToken)

        await loadCurrentUser()
    }

    func loadCurrentUser() async {
        guard let token else { return }

        do {
            let request = URLRequest.get(url: .jwtMe, bearerToken: token)
            let response: UserResponse = try await network.getJSON(
                request,
                type: UserResponse.self
            )
            self.user = response.toDomain
            print("✅ Usuario JWT cargado correctamente")
        } catch {
            print("❌ Token inválido, cerramos sesión: \(error)")
            logout()
        }
    }

    func register(email: String, password: String) async throws(NetworkError) {
        try await network.createUser(email: email, password: password)
    }

    func continueAsGuest() {
        token = nil
        user = nil
        isGuest = true
    }

    func logout() {
        token = nil
        user = nil
        isGuest = false
        KeychainService.delete(key: SessionKeys.jwtToken)
        didLogout = true
    }

    func exitGuest() {
        token = nil
        user = nil
        isGuest = false
    }

}
