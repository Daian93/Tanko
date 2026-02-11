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
        guard let savedToken = KeychainService.load(key: SessionKeys.jwtToken) else { return }
        self.token = savedToken
        Task { await loadCurrentUser() }
    }

    // Cambia tu función login por esta:
    func login(email: String, password: String, onCompletion: (() async -> Void)? = nil) async throws {
        let jwt = try await network.login(email: email, password: password)

        self.token = jwt
        self.isGuest = false
        KeychainService.save(jwt, key: SessionKeys.jwtToken)

        // Cargamos el usuario para tener su ID disponible
        await loadCurrentUser()
        
        await onCompletion?()
    }

    func loadCurrentUser() async {
        guard let token else { return }

        do {
            let request = URLRequest.get(url: .jwtMe, bearerToken: token)
            let response: UserResponse = try await network.getJSON(request, type: UserResponse.self)
            self.user = response.toDomain
            print("✅ Usuario JWT cargado correctamente")
        } catch {
            print("❌ Token inválido, cerramos sesión: \(error)")
            logout()
        }
    }

    func register(email: String, password: String) async throws {
        try await network.createUser(email: email, password: password)
    }

    func continueAsGuest() {
        token = nil
        user = nil
        isGuest = true
    }

    func logout(clearData: Bool = false, localRepo: LocalMangaCollectionRepository? = nil) {
            if clearData, let repo = localRepo {
                Task {
                    try? await repo.clearAll()
                    print("🗑️ Base de datos local borrada tras logout de usuario")
                }
            }
            
            token = nil
            user = nil
            isGuest = false
            KeychainService.delete(key: SessionKeys.jwtToken)

            NotificationCenter.default.post(
                name: .didLogout,
                object: nil
            )
        }
}

import Foundation

extension Notification.Name {
    static let didLogout = Notification.Name("didLogout")
}
