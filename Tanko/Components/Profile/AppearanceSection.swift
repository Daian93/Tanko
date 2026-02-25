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
            HStack {
                Label {
                    Text("appearance.darkMode")
                } icon: {
                    Image(
                        systemName: isDarkMode
                            ? "moon.stars.fill" : "moon.stars"
                    )
                    .foregroundStyle(.yellow)
                    .symbolEffect(.bounce, value: isDarkMode)
                }
                Spacer()
                Toggle(isOn: $isDarkMode) {}
                    .toggleStyle(.switch)
            }
            .background(.surface)

            // Language picker
            HStack {
                Label {
                    Text("appearance.language")
                } icon: {
                    Image(systemName: "globe")
                        .foregroundStyle(.blue)
                }
                Spacer()
                #if os(macOS)
                Picker("", selection: $appLanguage) {
                    ForEach(AppSettings.AppLanguage.allCases) { lang in
                        Text(lang.label)
                            .tag(lang)
                    }
                }
                .pickerStyle(.menu)
                #else
                Picker("", selection: $appLanguage) {
                    ForEach(AppSettings.AppLanguage.allCases) { lang in
                        Label {
                            Text(lang.label)
                        } icon: {
                            Text(lang.flag)
                        }
                        .tag(lang)
                    }
                }
                .pickerStyle(.menu)
                #endif
            }
            .background(.surface)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    @Previewable @State var isDark = false
    @Previewable @State var lang = AppSettings.AppLanguage.system

    List {
        AppearanceSection(isDarkMode: $isDark, appLanguage: $lang)
    }
}
