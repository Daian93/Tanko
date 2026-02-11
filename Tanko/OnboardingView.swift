//
//  OnboardingView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 9/2/26.
//

import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(SessionManager.self) private var session
    @Environment(\.modelContext) private var context

    @State private var activeSheet: Sheet?

    enum Sheet: Identifiable {
        case login, register
        var id: Int { hashValue }
    }

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
                Button("Iniciar sesión") {
                    activeSheet = .login
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(.borderedProminent)

                Button("Crear cuenta") {
                    activeSheet = .register
                }
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
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .login:
                LoginView(session: session, context: context)
            case .register:
                RegisterView(session: session)
            }
        }
    }
}
