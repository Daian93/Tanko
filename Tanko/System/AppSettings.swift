//
//  AppSettings.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 11/2/26.
//

import SwiftUI

@Observable
@MainActor
final class AppSettings {
    // We use @ObservationIgnored so that the Macro does not attempt to transform @AppStorage
    // We give it a private name for the ‘disk’
    @ObservationIgnored @AppStorage("profileEmoji") private var _profileEmoji:
        String = "🙂"
    @ObservationIgnored @AppStorage("profileUserName") private var _userName:
        String = ""
    @ObservationIgnored @AppStorage("isDarkMode") private var _isDarkMode:
        Bool = false
    @ObservationIgnored @AppStorage("appLanguage") private var _appLanguage:
        AppLanguage = .system

    // We create computed properties that the UI can observe
    // We use access and withMutation to manually ‘notify’ SwiftUI
    var profileEmoji: String {
        get {
            access(keyPath: \.profileEmoji)
            return _profileEmoji
        }
        set {
            withMutation(keyPath: \.profileEmoji) { _profileEmoji = newValue }
        }
    }

    var userName: String {
        get {
            access(keyPath: \.userName)
            return _userName
        }
        set { withMutation(keyPath: \.userName) { _userName = newValue } }
    }

    var isDarkMode: Bool {
        get {
            access(keyPath: \.isDarkMode)
            return _isDarkMode
        }
        set { withMutation(keyPath: \.isDarkMode) { _isDarkMode = newValue } }
    }

    var appLanguage: AppLanguage {
        get {
            access(keyPath: \.appLanguage)
            return _appLanguage
        }
        set { withMutation(keyPath: \.appLanguage) { _appLanguage = newValue } }
    }

    // MARK: - Computed property for current locale
    var locale: Locale {
        switch appLanguage {
        case .system: return .current
        case .spanish: return Locale(identifier: "es")
        case .english: return Locale(identifier: "en")
        }
    }

    // MARK: - Language Enum
    enum AppLanguage: String, CaseIterable, Identifiable {
        case system = "system"
        case spanish = "es"
        case english = "en"
        var id: String { rawValue }

        var label: LocalizedStringKey {
            switch self {
            case .system: return "language.system"
            case .spanish: return "language.spanish"
            case .english: return "language.english"
            }
        }
        var flag: String {
            switch self {
            case .system: return "🌐"
            case .spanish: return "🇪🇸"
            case .english: return "🇬🇧"
            }
        }
    }
}
