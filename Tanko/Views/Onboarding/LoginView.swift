//
//  LoginView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 9/2/26.
//

import SwiftData
import SwiftUI

struct LoginView: View {
    @Environment(SessionManager.self) private var session
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Environment(AppSettings.self) private var settings

    @State private var vm: LoginViewModel

    init(session: SessionManager, context: ModelContext) {
        _vm = State(
            wrappedValue: LoginViewModel(session: session, context: context)
        )
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    AuthHeader(
                        icon: "person.circle.fill",
                        title: "login.title",
                        subtitle: "login.subtitle"
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

                        AuthSubmitButton(
                            label: "button.login",
                            isLoading: vm.isLoading,
                            isFormValid: vm.isFormValid,
                            maxWidth: 100
                        ) {
                            Task {
                                await vm.login()
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
    let session = SessionManager()
    let settings = AppSettings()

    return LoginView(
        session: session,
        context: PreviewHelper.container.mainContext
    )
    .environment(session)
    .environment(settings)
    .modelContainer(PreviewHelper.container)
}
