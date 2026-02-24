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
            ScrollView {
                VStack(spacing: 20) {
                    // Header con icono
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(.tankoPrimary.opacity(0.1))
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: "person.badge.plus.fill")
                                .font(.system(size: 50))
                                .foregroundStyle(.tankoPrimary)
                        }
                        
                        Text("Crear cuenta")
                            .font(.title.bold())
                        
                        Text("Crea una cuenta para guardar tu colección en la nube")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    // Formulario
                    VStack(spacing: 16) {
                        // Email
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.subheadline.bold())
                                .foregroundStyle(.secondary)
                            
                            TextField("email@ejemplo.com", text: $vm.email)
                                .keyboardTypeCompatible(.emailAddress)
                                .textInputAutocapitalizationCompatible()
                                .padding()
                                .background(.surface)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        // Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Contraseña")
                                .font(.subheadline.bold())
                                .foregroundStyle(.secondary)
                            
                            SecureField("Mínimo 8 caracteres", text: $vm.password)
                                .padding()
                                .background(.surface)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        // Error message
                        if let error = vm.error {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundStyle(.tankoPrimary)
                                
                                Text(error)
                                    .font(.footnote)
                                    .foregroundStyle(.tankoPrimary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.tankoPrimary.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        // Register button
                        Button {
                            Task {
                                await vm.register()
                                if vm.error == nil { dismiss() }
                            }
                        } label: {
                            HStack {
                                if vm.isLoading {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Text("Crear cuenta")
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: 120)
                            .padding()
                            .background(
                                vm.isFormValid && !vm.isLoading
                                ? .tankoPrimary
                                    : Color.gray
                            )
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .disabled(!vm.isFormValid || vm.isLoading)
                        .padding(.top, 8)
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
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    RegisterView(session: SessionManager())
        .withPreviewEnvironment()
}
