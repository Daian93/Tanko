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

    @State private var vm: LoginViewModel

    init(session: SessionManager, context: ModelContext) {
        _vm = State(
            wrappedValue: LoginViewModel(session: session, context: context)
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Email") {
                    TextField("email@ejemplo.com", text: $vm.email)
                        .keyboardTypeCompatible(.emailAddress)
                        .textInputAutocapitalizationCompatible()
                        .textContentTypeCompatible(.username)
                }

                Section("Contraseña") {
                    SecureField("Mínimo 8 caracteres", text: $vm.password)
                        .textContentType(.password)
                }

                if let error = vm.error {
                    Text(error)
                        .foregroundStyle(AppColors.primary)
                        .font(.footnote)
                        .padding(.top, 4)
                }
            }
            .navigationTitle("Iniciar sesión")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        Task {
                            await vm.login()
                            if vm.error == nil { dismiss() }
                        }
                    } label: {
                        if vm.isLoading {
                            ProgressView()
                        } else {
                            Text("Entrar")
                        }
                    }
                    .disabled(!vm.isFormValid || vm.isLoading)
                }
            }
        }
    }
}

#Preview {
    let session = SessionManager()

    return LoginView(
        session: session,
        context: PreviewHelper.container.mainContext
    )
    .environment(session)
    .modelContainer(PreviewHelper.container)
}
