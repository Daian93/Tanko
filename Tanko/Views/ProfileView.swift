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

        NavigationStack {
            #if os(macOS)
                macContent(settings: _settings)
            #else
                iosContent(settings: settings)
            #endif
        }
        .sheet(isPresented: $showEmojiPicker) {
            EmojiPickerView(selectedEmoji: $settings.profileEmoji)
        }
    }

    // MARK: - iOS Layout
    @ViewBuilder
    private func iosContent(settings: Bindable<AppSettings>) -> some View {
        Form {
            Section("Personalización") {
                VStack(spacing: 15) {
                    profileImageSection

                    TextField("Tu nombre", text: settings.userName)
                        .multilineTextAlignment(.center)
                        .font(.headline)
                }
                .padding(.vertical)
            }

            Section("App") {
                Toggle(isOn: settings.isDarkMode) {
                    Label(
                        "Modo oscuro",
                        systemImage: settings.isDarkMode.wrappedValue
                            ? "moon.fill" : "sun.max"
                    )
                }
            }

            Section {
                logoutButton
            } footer: {
                if session.isGuest {
                    Text(
                        "Estás como invitado. Crea una cuenta para no perder tus datos."
                    )
                }
            }
        }
        .navigationTitle("Ajustes")
    }

    // MARK: - macOS Layout
    @ViewBuilder
    private func macContent(settings: Bindable<AppSettings>) -> some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("Ajustes")
                    .font(.system(size: 30, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 20) {
                    profileImageSection

                    TextField("Tu nombre", text: settings.userName)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.center)
                        .font(.title3)
                        .frame(maxWidth: 250)
                }
                .padding(30)
                .background(Color.secondary.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 20))

                VStack(alignment: .leading, spacing: 20) {
                    Toggle("Modo oscuro", isOn: settings.isDarkMode)
                        .toggleStyle(.switch)

                    Divider()

                    logoutButton
                        .buttonStyle(.borderedProminent)
                }
                .padding(20)

                if session.isGuest {
                    Text("Modo invitado: los datos son locales.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(40)
        }
    }

    // MARK: - Shared Components

    private var profileImageSection: some View {
        Text(settings.profileEmoji)
            .font(.system(size: 80))
            .padding()
            .background(Circle().fill(Color.blue.opacity(0.1)))
            .onTapGesture { showEmojiPicker = true }
    }

    private var logoutButton: some View {
        Button(role: .destructive) {
            handleLogout()
        } label: {
            Label(
                session.isGuest ? "Volver al Inicio" : "Cerrar Sesión",
                systemImage: session.isGuest
                    ? "arrow.left.circle" : "rectangle.portrait.and.arrow.right"
            )
            .foregroundStyle(.red)
        }
    }

    private func handleLogout() {
        withAnimation {
            if session.isGuest {
                session.exitGuest()
            } else {
                session.logout()
            }
        }
    }
}

#Preview {
    ProfileView()
        .withPreviewEnvironment()
}
