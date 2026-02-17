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

    @Bindable private var vm: RegisterViewModel

    init(session: SessionManager) {
        self.vm = RegisterViewModel(session: session)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Email") {
                    TextField("email@ejemplo.com", text: $vm.email)
                        .keyboardTypeCompatible(.emailAddress)
                        .textInputAutocapitalizationCompatible()
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
            .navigationTitle("Crear cuenta")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        Task {
                            await vm.register()
                            if vm.error == nil { dismiss() }
                        }
                    } label: {
                        if vm.isLoading {
                            ProgressView()
                        } else {
                            Text("Crear")
                        }
                    }
                    .disabled(!vm.isFormValid || vm.isLoading)
                }
            }
        }
    }
}

#Preview {
    RegisterView(session: SessionManager())
        .withPreviewEnvironment()
}
