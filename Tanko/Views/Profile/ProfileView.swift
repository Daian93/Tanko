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
        .id(settings.appLanguage)
        .sheet(isPresented: $showEmojiPicker) {
            EmojiPickerView(selectedEmoji: $settings.profileEmoji)
        }
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
            .listRowBackground(Color.tankoCardSurface)
            

            // Stats of the collection (only if there are mangas)
            if !collectionVM.mangas.isEmpty {
                Section("profile.stats") {
                    ProfileStatsSection(stats: collectionVM.collectionStats)
                }
                .listRowBackground(Color.tankoCardSurface)
            }

            // Appearance settings (theme + language)
            Section("profile.appearance") {
                AppearanceSection(
                    isDarkMode: settings.isDarkMode,
                    appLanguage: settings.appLanguage
                )
            }
            .listRowBackground(Color.tankoCardSurface)

            // Contact and support options
            Section("profile.support") {
                ContactSection()
            }
            .listRowBackground(Color.tankoCardSurface)

            // App version and logout
            Section {
                AppVersionSection()
            }
            .listRowBackground(Color.tankoCardSurface)

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
            .listRowBackground(Color.tankoCardSurface)
        }
        .navigationTitle("profile.title")
        .scrollContentBackground(.hidden)
        .background(.tankoBackground)
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

                // Appearance
                macSection(title: "profile.appearance") {
                    AppearanceSection(
                        isDarkMode: settings.isDarkMode,
                        appLanguage: settings.appLanguage
                    )
                }

                // Contact and support
                macSection(title: "profile.support") {
                    ContactSection()
                }

                // Version + Logout
                VStack(alignment: .leading, spacing: 12) {
                    AppVersionSection()
                    Divider()
                    // Logout
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
                    .background(.surface)

                    if session.isGuest {
                        Text("profile.guest.text")
                            .font(.caption)
                            .foregroundStyle(.tankoSecondary)
                    }
                }
                .macCard()
            }
            .padding(32)
            .background(.tankoBackground)
            .frame(maxWidth: .infinity)
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
        
        .background(.surface)
        .macCard()
    }
}

// MARK: - Mac Card ViewModifier

private extension View {
    func macCard() -> some View {
        self
            .padding(20)
            .background(.surface)
            .frame(maxWidth: .infinity, alignment: .leading)
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
