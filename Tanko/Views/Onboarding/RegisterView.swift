//
//  RegisterView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 9/2/26.
//

import SwiftData
import SwiftUI

struct RegisterView: View {
    @Environment(SessionManager.self) private var session
    @Environment(\.dismiss) private var dismiss
    @Environment(AppSettings.self) private var settings
    @Environment(\.modelContext) private var context

    @State private var vm: RegisterViewModel

    init(session: SessionManager, context: ModelContext) {
        _vm = State(
            wrappedValue: RegisterViewModel(session: session, context: context)
        )
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    #if os(macOS)
                        Spacer()
                    #endif
                    VStack(spacing: 20) {
                        AuthHeader(
                            icon: "person.badge.plus.fill",
                            title: "register.title",
                            subtitle: "register.subtitle"
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
                            .padding(.top, 8)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                    #if os(macOS)
                        Spacer()
                    #endif
                }
                #if os(macOS)
                    .frame(maxWidth: .infinity, minHeight: 520)
                #endif
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
    RegisterView(
        session: SessionManager(),
        context: PreviewHelper.container.mainContext
    )
    .withPreviewEnvironment()
}
