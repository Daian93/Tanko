//
//  LoginViewModel.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 10/2/26.
//

import SwiftData
import SwiftUI

@Observable
@MainActor
final class LoginViewModel {
    private let session: SessionManager
    private let context: ModelContext

    var email = ""
    var password = ""
    var error: String?
    var isLoading = false

    init(session: SessionManager, context: ModelContext) {
        self.session = session
        self.context = context
    }

    // Validaciones en tiempo real
    var isFormValid: Bool {
        AuthValidator.isValidEmail(email)
            && AuthValidator.isValidPassword(password)
    }

    func login() async {
        guard isFormValid else { return }

        isLoading = true
        error = nil

        do {
            try await session.login(email: email, password: password)

            // Sincronización local → remoto
            let localRepo = LocalMangaCollectionRepository(context: context)
            let remoteRepo = RemoteMangaCollectionRepository(
                network: Network(),
                session: session,
                localRepo: localRepo
            )
            let localMangas = try await localRepo.getCollection()

            for manga in localMangas {
                try? await remoteRepo.add(manga)
            }

        } catch {
            // Siempre en MainActor para poder mutar propiedades @Observable
            await MainActor.run {
                self.error = error.localizedDescription
            }
        }

        await MainActor.run {
            self.isLoading = false
        }
    }

}
