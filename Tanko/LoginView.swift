//
//  LoginView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 9/2/26.
//

import SwiftUI
import SwiftData

struct LoginView: View {
    @Environment(SessionManager.self) private var session
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @Bindable private var vm: LoginViewModel

    init(session: SessionManager, context: ModelContext) {
        self.vm = LoginViewModel(session: session, context: context)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Email") {
                    TextField("email@ejemplo.com", text: $vm.email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                }

                Section("Contraseña") {
                    SecureField("Mínimo 8 caracteres", text: $vm.password)
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
