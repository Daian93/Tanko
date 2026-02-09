//
//  RegisterView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 9/2/26.
//

import SwiftUI

struct RegisterView: View {
    @Environment(SessionManager.self) private var session
    @Environment(\.dismiss) private var dismiss

    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var error: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("Email") {
                    TextField("email@ejemplo.com", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                }

                Section("Contraseña") {
                    SecureField("Mínimo 8 caracteres", text: $password)
                }

                if let errorMessage = error {
                    Text(errorMessage)
                        .foregroundStyle(AppColors.primary)
                }
            }
            .navigationTitle("Crear cuenta")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Button("Crear") {
                            register()
                        }
                    }
                }
            }
        }
    }

    private func register() {
        isLoading = true
        self.error = nil

        Task {
            do {
                try await session.register(
                    email: email,
                    password: password
                )

                try await session.login(
                    email: email,
                    password: password
                )

                dismiss()

            } catch let authError as LocalizedError {
                self.error = authError.errorDescription
            } catch {
                self.error = String(localized: "auth.error.unknown")
            }

            isLoading = false
        }
    }
}
