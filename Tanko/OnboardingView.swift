//
//  OnboardingView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 9/2/26.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(SessionManager.self) private var session
    @State private var showLogin = false
    @State private var showRegister = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            VStack(spacing: 12) {
                Text("Tankō")
                    .font(.largeTitle.bold())
                Text("Gestiona tu colección de manga")
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(spacing: 16) {
                Button("Iniciar sesión") { showLogin = true }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.borderedProminent)

                Button("Crear cuenta") { showRegister = true }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.bordered)

                Button("Continuar como invitado") {
                    session.continueAsGuest()
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(.bordered)
            }

            Spacer()
        }
        .padding()
        .sheet(isPresented: $showLogin) { LoginView() }
        .sheet(isPresented: $showRegister) { RegisterView() }
    }
}
