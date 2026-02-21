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
            ScrollView {
                VStack(spacing: 20) {
                    // Header con icono
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color("TankoPrimary").opacity(0.1))
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 50))
                                .foregroundStyle(Color("TankoPrimary"))
                        }
                        
                        Text("Iniciar sesión")
                            .font(.title.bold())
                        
                        Text("Accede a tu cuenta para sincronizar tu colección")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 15)
                    
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
                                .textContentTypeCompatible(.username)
                                .padding()
                                .background(AppColors.surface)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        // Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Contraseña")
                                .font(.subheadline.bold())
                                .foregroundStyle(.secondary)
                            
                            SecureField("Mínimo 8 caracteres", text: $vm.password)
                                .textContentType(.password)
                                .padding()
                                .background(AppColors.surface)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        // Error message
                        if let error = vm.error {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundStyle(AppColors.primary)
                                
                                Text(error)
                                    .font(.footnote)
                                    .foregroundStyle(AppColors.primary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(AppColors.primary.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        // Login button
                        Button {
                            Task {
                                await vm.login()
                                if vm.error == nil { dismiss() }
                            }
                        } label: {
                            HStack {
                                if vm.isLoading {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Text("Entrar")
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: 100)
                            .padding()
                            .background(
                                vm.isFormValid && !vm.isLoading
                                    ? Color("TankoPrimary")
                                    : Color.gray
                            )
                            .foregroundStyle(AppColors.background)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .disabled(!vm.isFormValid || vm.isLoading)
                        .padding(.top, 2)
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
    let session = SessionManager()

    return LoginView(
        session: session,
        context: PreviewHelper.container.mainContext
    )
    .environment(session)
    .modelContainer(PreviewHelper.container)
}
