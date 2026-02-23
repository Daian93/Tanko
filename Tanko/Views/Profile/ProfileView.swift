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
    @Environment(UserMangaCollectionViewModel.self) private var collectionVM

    @State private var showEmojiPicker = false

    var body: some View {
        @Bindable var settings = settings

        NavigationStack {
            #if os(macOS)
                macContent(settings: _settings)
            #else
                iosContent(settings: _settings)
            #endif
        }
        .sheet(isPresented: $showEmojiPicker) {
            EmojiPickerView(selectedEmoji: $settings.profileEmoji)
        }
        .background(.tankoBackground)
    }
}

// MARK: - iOS Layout

extension ProfileView {

    @ViewBuilder
    func iosContent(settings: Bindable<AppSettings>) -> some View {
        Form {

            // Header with username and emoji
            Section("profile.personalization") {
                ProfileHeaderSection(
                    userName: settings.userName,
                    emoji: settings.profileEmoji.wrappedValue,
                    onTapEmoji: { showEmojiPicker = true }
                )
            }

            // Stats of the collection (only if there are mangas)
            if !collectionVM.mangas.isEmpty {
                Section("profile.stats") {
                    ProfileStatsSection(stats: collectionVM.collectionStats)
                }
            }

            // Appearance settings (theme + language)
            Section("profile.appearance") {
                AppearanceSection(
                    isDarkMode: settings.isDarkMode,
                    appLanguage: settings.appLanguage
                )
                .onChange(of: settings.appLanguage.wrappedValue) { _, new in
                    settings.wrappedValue.updateLanguage(new)
                }
            }

            // Contact and support options
            Section("profile.support") {
                ContactSection()
            }

            // App version and logout
            Section {
                AppVersionSection()
            }

            // Cerrar sesión
            Section {
                LogoutSection(
                    isGuest: session.isGuest,
                    action: handleLogout
                )
            } footer: {
                if session.isGuest {
                    Text("profile.guest.text")
                }
            }
        }
        .navigationTitle("profile.title")
    }
}

// MARK: - macOS Layout

extension ProfileView {

    @ViewBuilder
    func macContent(settings: Bindable<AppSettings>) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                Text("profile.title")
                    .font(.system(size: 30, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)

                // Header
                ProfileHeaderSection(
                    userName: settings.userName,
                    emoji: settings.profileEmoji.wrappedValue,
                    onTapEmoji: { showEmojiPicker = true }
                )
                .macCard()

                // Stats
                if !collectionVM.mangas.isEmpty {
                    macSection(title: "profile.stats") {
                        ProfileStatsSection(stats: collectionVM.collectionStats)
                    }
                }

                // Apariencia
                macSection(title: "profile.appearance") {
                    AppearanceSection(
                        isDarkMode: settings.isDarkMode,
                        appLanguage: settings.appLanguage
                    )
                    .onChange(of: settings.appLanguage.wrappedValue) { _, new in
                        settings.wrappedValue.updateLanguage(new)
                    }
                }

                // Soporte
                macSection(title: "profile.support") {
                    ContactSection()
                }

                // Versión + Logout
                VStack(alignment: .leading, spacing: 12) {
                    AppVersionSection()
                    Divider()
                    // Logout destacado en color tankoPrimary
                    Button(action: handleLogout) {
                        HStack(spacing: 10) {
                            Image(systemName: session.isGuest
                                  ? "arrow.left.circle.fill"
                                  : "rectangle.portrait.and.arrow.right.fill")
                                .font(.system(size: 16, weight: .semibold))
                            Text(session.isGuest ? "logout.guest" : "logout.user")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        .foregroundStyle(.tankoPrimary)
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(.plain)

                    if session.isGuest {
                        Text("profile.guest.text")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .macCard()
            }
            .padding(32)
            .frame(maxWidth: .infinity) // ✅ Ocupa todo el ancho
        }
    }

    // MARK: - Mac Card Helper

    @ViewBuilder
    private func macSection<Content: View>(
        title: LocalizedStringKey,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)
            content()
        }
        .macCard()
    }
}

// MARK: - Mac Card ViewModifier

private extension View {
    func macCard() -> some View {
        self
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading) // ✅ Alarga hasta los bordes
            .background(.tankoSecondary.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Actions

extension ProfileView {

    private func handleLogout() {
        withAnimation(.easeInOut(duration: 0.2)) {
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
