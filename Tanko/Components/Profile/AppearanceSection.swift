//
//  AppearanceSection.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/2/26.
//

import SwiftUI

struct AppearanceSection: View {
    @Binding var isDarkMode: Bool
    @Binding var appLanguage: AppSettings.AppLanguage

    var body: some View {
        Group {
            // Dark mode toggle
            Toggle(isOn: $isDarkMode) {
                Label {
                    Text("appearance.darkMode")
                } icon: {
                    Image(systemName: isDarkMode ? "moon.stars.fill" : "moon.stars")
                        .foregroundStyle(.yellow)
                        .symbolEffect(.bounce, value: isDarkMode)
                }
            }

            // Language picker
            Picker(selection: $appLanguage) {
                ForEach(AppSettings.AppLanguage.allCases) { lang in
                    HStack(spacing: 6) {
                        Text(lang.flag)
                        Text(lang.label)
                    }
                    .tag(lang)
                }
            } label: {
                Label {
                    Text("appearance.language")
                } icon: {
                    Image(systemName: "globe")
                        .foregroundStyle(.blue)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var isDark = false
    @Previewable @State var lang = AppSettings.AppLanguage.system

    List {
        AppearanceSection(isDarkMode: $isDark, appLanguage: $lang)
    }
}
