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
    @State private var isAnimating = false

    enum Sheet: Identifiable {
        case login, register
        var id: Int { hashValue }
    }

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color("TankoPrimary").opacity(0.9),
                    Color("TankoSecondary").opacity(0.7),
                    Color("TankoPrimary").opacity(0.6)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Logo and title section
                VStack(spacing: 24) {
                    // Animated book icon
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.2))
                            .frame(width: 140, height: 140)
                            .scaleEffect(isAnimating ? 1.1 : 1.0)
                            .animation(
                                .easeInOut(duration: 2.0)
                                .repeatForever(autoreverses: true),
                                value: isAnimating
                            )
                        
                        Circle()
                            .fill(.white.opacity(0.3))
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: "books.vertical.fill")
                            .font(.system(size: 55))
                            .foregroundStyle(.white)
                            .rotationEffect(.degrees(isAnimating ? 5 : -5))
                            .animation(
                                .easeInOut(duration: 2.0)
                                .repeatForever(autoreverses: true),
                                value: isAnimating
                            )
                    }
                    .padding(.bottom, 16)
                    
                    VStack(spacing: 12) {
                        Text("TANKŌ")
                            .font(.system(size: 48, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                        
                        Text("Tu colección de manga,\nsiempre contigo")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundStyle(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                Spacer()
                
                // Buttons section with card style
                VStack(spacing: 16) {
                    // Login button
                    Button {
                        activeSheet = .login
                    } label: {
                        HStack {
                            Image(systemName: "person.fill")
                                .font(.title3)
                            Text("Iniciar sesión")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.white)
                        .foregroundStyle(Color("TankoPrimary"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                    }
                    
                    // Register button
                    Button {
                        activeSheet = .register
                    } label: {
                        HStack {
                            Image(systemName: "person.badge.plus")
                                .font(.title3)
                            Text("Crear cuenta")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.white.opacity(0.2))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.white.opacity(0.5), lineWidth: 2)
                        )
                    }
                    
                    // Guest button
                    Button {
                        session.continueAsGuest()
                    } label: {
                        HStack {
                            Image(systemName: "person.slash")
                                .font(.title3)
                            Text("Continuar como invitado")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .foregroundStyle(.white.opacity(0.8))
                        .padding(.vertical, 12)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
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
                    .presentationCornerRadius(28)
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
                    .presentationCornerRadius(28)
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
