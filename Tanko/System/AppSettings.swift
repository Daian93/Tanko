//
//  AppSettings.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 11/2/26.
//

//
//  AppSettings.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 11/2/26.
//

import SwiftUI
import Observation

@Observable
@MainActor
final class AppSettings {
    var profileEmoji: String
    var userName: String
    var isDarkMode: Bool
    var appLanguage: AppLanguage

    // Computed property for current locale
    var locale: Locale {
        switch appLanguage {
        case .system:
            return .current
        case .spanish:
            return Locale(identifier: "es")
        case .english:
            return Locale(identifier: "en")
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
            case .system:   return "language.system"
            case .spanish:  return "language.spanish"
            case .english:  return "language.english"
            }
        }

        var flag: String {
            switch self {
            case .system:   return "🌐"
            case .spanish:  return "🇪🇸"
            case .english:  return "🇬🇧"
            }
        }

        var locale: Locale {
            switch self {
            case .system: return .current
            case .spanish: return Locale(identifier: "es")
            case .english: return Locale(identifier: "en")
            }
        }
    }

    // MARK: - Initialization

    init() {
        self.profileEmoji = UserDefaults.standard.string(forKey: "profileEmoji") ?? "🙂"
        self.userName     = UserDefaults.standard.string(forKey: "profileUserName") ?? ""
        self.isDarkMode   = UserDefaults.standard.bool(forKey: "isDarkMode")
        let savedLanguage = UserDefaults.standard.string(forKey: "appLanguage") ?? AppLanguage.system.rawValue
        self.appLanguage  = AppLanguage(rawValue: savedLanguage) ?? .system
    }

    // MARK: - Update Methods

    func updateDarkMode(_ value: Bool) {
        isDarkMode = value
        UserDefaults.standard.set(value, forKey: "isDarkMode")
    }

    func updateName(_ value: String) {
        userName = value
        UserDefaults.standard.set(value, forKey: "profileUserName")
    }

    func updateEmoji(_ value: String) {
        profileEmoji = value
        UserDefaults.standard.set(value, forKey: "profileEmoji")
    }

    func updateLanguage(_ value: AppLanguage) {
        appLanguage = value
        UserDefaults.standard.set(value.rawValue, forKey: "appLanguage")
    }
}
