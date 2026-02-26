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
    @Environment(AppSettings.self) private var settings

    @State private var vm: RegisterViewModel

    init(session: SessionManager) {
        self.vm = RegisterViewModel(session: session)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    AuthHeader(
                        icon: "person.badge.plus.fill",
                        title: "register.title",
                        subtitle: "register.subtitle",
                    )

                    // Form
                    VStack(spacing: 16) {
                        AuthTextField(
                            label: "email.label",
                            placeholder: "email.placeholder",
                            text: $vm.email
                        )

                        AuthSecureField(
                            label: "password.label",
                            placeholder: "password.placeholder",
                            text: $vm.password
                        )

                        if let error = vm.error {
                            AuthErrorView(error: error)
                        }

                        // Button
                        AuthSubmitButton(
                            label: "register.title",
                            isLoading: vm.isLoading,
                            isFormValid: vm.isFormValid,
                            maxWidth: 120
                        ) {
                            Task {
                                await vm.register()
                                if vm.error == nil { dismiss() }
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
            #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("button.cancel") {
                        dismiss()
                    }
                }
            }
            .background(.tankoBackground)
        }
        .id(settings.appLanguage)
    }
}

#Preview {
    RegisterView(session: SessionManager())
        .withPreviewEnvironment()
}
