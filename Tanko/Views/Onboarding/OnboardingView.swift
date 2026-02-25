//
//  OnboardingView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 9/2/26.
//

import SwiftData
import SwiftUI

struct OnboardingView: View {
    @Environment(SessionManager.self) private var session
    @Environment(\.modelContext) private var context

    @State private var activeSheet: Sheet?
    @State private var isAnimating = false

    enum Sheet: Identifiable {
        case login, register
        var id: Int { hashValue }
    }

    var body: some View {
        ZStack {
            OnboardingBackground()

            VStack(spacing: 0) {
                Spacer()

                OnboardingLogo(isAnimating: isAnimating)

                Spacer()
                Spacer()

                OnboardingActions(
                    onLogin: { activeSheet = .login },
                    onRegister: { activeSheet = .register },
                    onGuest: { session.continueAsGuest() }
                )
            }
        }
        .onAppear {
            isAnimating = true
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .login:
                LoginView(session: session, context: context)
                    #if os(iOS)
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                    #endif
                    #if os(macOS)
                        .frame(minWidth: 450, idealWidth: 500, maxWidth: 550)
                        .frame(minHeight: 500, idealHeight: 550, maxHeight: 600)
                    #endif
            case .register:
                RegisterView(session: session)
                    #if os(iOS)
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                    #endif
                    #if os(macOS)
                        .frame(minWidth: 450, idealWidth: 500, maxWidth: 550)
                        .frame(minHeight: 550, idealHeight: 600, maxHeight: 650)
                    #endif
            }
        }
    }
}

#Preview {
    OnboardingView()
        .withPreviewEnvironment()
}
