//
//  RegisterViewModel.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 10/2/26.
//

import SwiftUI
import SwiftData

@Observable
@MainActor
final class RegisterViewModel {
    private let session: SessionManager

    var email = ""
    var password = ""
    var error: String?
    var isLoading = false

    init(session: SessionManager) {
        self.session = session
    }

    var isFormValid: Bool {
        AuthValidator.isValidEmail(email) && AuthValidator.isValidPassword(password)
    }

    func register() async {
        guard isFormValid else { return }

        isLoading = true
        error = nil

        do {
            try await session.register(email: email, password: password)
            try await session.login(email: email, password: password)
        } catch let authError as LocalizedError {
            await MainActor.run {
                self.error = authError.errorDescription
            }
        } catch {
            await MainActor.run {
                self.error = String(localized: "auth.error.unknown")
            }
        }

        await MainActor.run {
            self.isLoading = false
        }
    }
}
