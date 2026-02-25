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
    var error: AuthError?
    var isLoading = false

    var isFormValid: Bool {
        AuthValidator.isValidEmail(email)
            && AuthValidator.isValidPassword(password)
    }

    init(session: SessionManager, context: ModelContext) {
        self.session = session
        self.context = context
    }

    func login() async {
        guard isFormValid else { return }
        isLoading = true

        do {
            try await session.login(email: email, password: password)

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
            switch networkError {
            case .status(401): self.error = .invalidCredentials
            case .noInternet: self.error = .noInternet
            case .timedOut: self.error = .timedOut
            default: self.error = .unknown
            }
        } catch {
            self.error = .unknown
        }

        isLoading = false
    }
}
