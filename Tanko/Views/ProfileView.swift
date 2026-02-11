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

    var body: some View {
        @Bindable var settings = settings
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
        }
    }

    private func handleLogout() {
        withAnimation {
            session.exitGuest()
        }
    }
}
