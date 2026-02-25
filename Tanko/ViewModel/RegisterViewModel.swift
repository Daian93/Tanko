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

        do {
            try await session.register(email: email, password: password)
            try await session.login(email: email, password: password)
        } catch let networkError as NetworkError {
            switch networkError {
            case .status(409): self.error = .emailAlreadyInUse
            case .noInternet: self.error = .noInternet
            case .timedOut: self.error = .timedOut
            default: self.error = .unknown
            }
        } catch {
            self.error = .unknown
        }

        self.isLoading = false
    }
}
