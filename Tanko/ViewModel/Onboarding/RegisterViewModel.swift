//
//  RegisterViewModel.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 10/2/26.
//

import SwiftData
import SwiftUI

@Observable
@MainActor
final class RegisterViewModel {
    private let session: SessionManager
    private let context: ModelContext

    var email = ""
    var password = ""
    var error: AuthError?
    var isLoading = false

    init(session: SessionManager, context: ModelContext) {
        self.session = session
        self.context = context
    }

    var isFormValid: Bool {
        AuthValidator.isValidEmail(email)
            && AuthValidator.isValidPassword(password)
    }

    func register() async {
        guard isFormValid else { return }

        isLoading = true
        error = nil
        defer { isLoading = false }

        do {
            try await session.register(email: email, password: password)
            try await session.login(email: email, password: password)

            // Migrate guest local mangas to the new account
            let localRepo = LocalMangaCollectionRepository(context: context)
            let guestMangas = try await localRepo.getCollection()

            if !guestMangas.isEmpty {
                let remoteRepo = RemoteMangaCollectionRepository(
                    network: Network(),
                    session: session,
                    localRepo: localRepo
                )

                for manga in guestMangas {
                    try? await remoteRepo.add(mangaData: manga)
                }

                await LocalDatabaseCleaner.clear(context: context)
            }

        } catch let networkError as NetworkError {
            self.error = networkError.asAuthError
        } catch {
            self.error = .unknown
        }
    }
}

