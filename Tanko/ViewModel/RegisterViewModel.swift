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

    var email = ""
    var password = ""
    var error: AuthError?
    var isLoading = false

    init(session: SessionManager) {
        self.session = session
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
        } catch {
            self.error = AuthError(from: error)
        }
    }
}
