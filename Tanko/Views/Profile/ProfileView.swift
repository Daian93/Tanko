//
//  ProfileView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 11/2/26.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(SessionManager.self) private var session
    @Environment(AppSettings.self) private var settings

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

extension ProfileView {

    @ViewBuilder
    func iosContent(settings: Bindable<AppSettings>) -> some View {
        Form {

            Section("profile.personalization") {
                ProfileHeaderSection(
                    userName: settings.userName,
                    emoji: settings.profileEmoji.wrappedValue,
                    onTapEmoji: { showEmojiPicker = true }
                )
            }

            Section("profile.appearance") {
                AppearanceSection(isDarkMode: settings.isDarkMode)
            }

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

extension ProfileView {
    @ViewBuilder
    func macContent(settings: Bindable<AppSettings>) -> some View {
        ScrollView {
            VStack(spacing: 40) {

                Text("profile.title")
                    .font(.system(size: 30, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)

                ProfileHeaderSection(
                    userName: settings.userName,
                    emoji: settings.profileEmoji.wrappedValue,
                    onTapEmoji: { showEmojiPicker = true }
                )
                .padding(30)
                .background(.tankoSecondary.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 20))

                VStack(alignment: .leading, spacing: 20) {
                    AppearanceSection(isDarkMode: settings.isDarkMode)
                    Divider()
                    LogoutSection(
                        isGuest: session.isGuest,
                        action: handleLogout
                    )
                }
                .padding(20)

                if session.isGuest {
                    Text("profile.guest.text")
                        .font(.caption)
                        .foregroundStyle(.tankoSecondary)
                }
            }
            .padding(40)
        }
    }
}

extension ProfileView {

    private func handleLogout() {
        let wasGuest = session.isGuest

        if wasGuest {
            session.exitGuest()
        } else {
            session.logout()
        }
    }
}

#Preview {
    ProfileView()
        .withPreviewEnvironment()
}
