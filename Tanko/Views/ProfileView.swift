//
//  ProfileView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 11/2/26.
//

import SwiftData
import SwiftUI

struct ProfileView: View {
    @Environment(SessionManager.self) private var session
    @Environment(AppSettings.self) private var settings
    @Environment(\.modelContext) private var context
    @State private var showEmojiPicker = false
    @State private var showOnboarding = false

    var body: some View {
        @Bindable var settings = settings
        
        /*private var headerView: some View {
         HStack(spacing: 16) {
             Circle()
                 .fill(Color.red.opacity(0.1))
                 .frame(width: 70, height: 70)
                 .overlay(
                     Text(
                         session.isGuest
                         ? "👤"
                         : session.user?.email.prefix(2).uppercased() ?? "TU"
                     )
                     .font(.headline)
                     .foregroundStyle(.red)
                 )

             VStack(alignment: .leading) {
                 Text(session.isGuest ? "Modo Invitado" : "Mi Perfil")
                     .font(.title3.bold())

                 Text("\(userMangas.count) mangas en total")
                     .font(.caption)
                     .foregroundStyle(.secondary)
             }
             Spacer()
         }
         .padding(.horizontal)
     }*/
        NavigationStack {
            Form {
                Section("Personalización") {
                    HStack {
                        Spacer()
                        VStack {
                            Text(settings.profileEmoji)
                                .font(.system(size: 80))
                                .padding()
                                .background(
                                    Circle().fill(Color.blue.opacity(0.1))
                                )
                                .onTapGesture { showEmojiPicker = true }

                            TextField("Tu nombre", text: $settings.userName)
                                .multilineTextAlignment(.center)
                                .font(.headline)
                        }
                        Spacer()
                    }
                    .padding(.vertical)
                }

                Section("App") {
                    Toggle(isOn: $settings.isDarkMode) {
                        Label(
                            "Modo oscuro",
                            systemImage: settings.isDarkMode
                                ? "moon.fill" : "sun.max"
                        )
                    }
                    .onChange(of: settings.isDarkMode) { oldValue, newValue in
                        settings.updateDarkMode(newValue)
                    }
                }

                Section {
                    Section {
                        Button(role: .destructive) {
                            handleLogout()
                        } label: {
                            Label(
                                session.isGuest
                                    ? "Volver al Inicio" : "Cerrar Sesión",
                                systemImage: session.isGuest
                                    ? "arrow.left.circle"
                                    : "rectangle.portrait.and.arrow.right"
                            )
                        }

                    }
                } footer: {
                    if session.isGuest {
                        Text(
                            "Estás como invitado. Crea una cuenta para no perder tus datos al cambiar de dispositivo."
                        )
                    }
                }
            }
            .navigationTitle("Ajustes")
            .sheet(isPresented: $showEmojiPicker) {
                EmojiPickerView(selectedEmoji: $settings.profileEmoji)
            }
            .toolbar {

                            if session.isGuest {
                                ToolbarItem(placement: .topBarTrailing) {
                                    Button {
                                        withAnimation {
                                            session.exitGuest()
                                            showOnboarding = true
                                        }
                                    } label: {
                                        Image(systemName: "rectangle.portrait.and.arrow.right")
                                            .foregroundStyle(AppColors.primary)
                                    }
                                }
                            }

                            if session.isAuthenticated {
                                ToolbarItem(placement: .topBarTrailing) {
                                    Button(role: .destructive) {
                                        withAnimation {
                                            session.logout()
                                        }
                                    } label: {
                                        Image(systemName: "rectangle.portrait.and.arrow.right")
                                            .foregroundStyle(AppColors.primary)
                                    }
                                }
                            }
                        }

        }
    }

    private func handleLogout() {
        withAnimation {
            session.exitGuest()
        }
    }
}
