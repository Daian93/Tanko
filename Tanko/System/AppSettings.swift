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
    // Current user ID used to namespace all keys — nil = guest
    private var currentUserID: String = "guest"

    // In-memory values (loaded from UserDefaults with per-user keys)
    private var _profileEmoji: String = "🙂"
    private var _userName: String = ""
    private var _isDarkMode: Bool = false
    private var _appLanguage: AppLanguage = .system

    // MARK: - Per-user key helpers

    private func key(_ base: String) -> String { "\(base).\(currentUserID)" }

    private func load() {
        let defaults = UserDefaults.standard
        withMutation(keyPath: \.profileEmoji) {
            _profileEmoji = defaults.string(forKey: key("profileEmoji")) ?? "🙂"
        }
        withMutation(keyPath: \.userName) {
            _userName = defaults.string(forKey: key("profileUserName")) ?? ""
        }
        withMutation(keyPath: \.isDarkMode) {
            _isDarkMode = defaults.bool(forKey: key("isDarkMode"))
        }
        withMutation(keyPath: \.appLanguage) {
            let raw =
                defaults.string(forKey: key("appLanguage"))
                ?? AppLanguage.system.rawValue
            _appLanguage = AppLanguage(rawValue: raw) ?? .system
        }
    }

    private func save(_ value: Any?, forKey base: String) {
        UserDefaults.standard.set(value, forKey: key(base))
    }

    // MARK: - Called on login / logout

    func switchUser(to userID: String?) {
        currentUserID = userID ?? "guest"
        load()
    }

    // MARK: - Observed properties

    var profileEmoji: String {
        get {
            access(keyPath: \.profileEmoji)
            return _profileEmoji
        }
        set {
            withMutation(keyPath: \.profileEmoji) { _profileEmoji = newValue }
            save(newValue, forKey: "profileEmoji")
        }
    }

    var userName: String {
        get {
            access(keyPath: \.userName)
            return _userName
        }
        set {
            withMutation(keyPath: \.userName) { _userName = newValue }
            save(newValue, forKey: "profileUserName")
        }
    }

    var isDarkMode: Bool {
        get {
            access(keyPath: \.isDarkMode)
            return _isDarkMode
        }
        set {
            withMutation(keyPath: \.isDarkMode) { _isDarkMode = newValue }
            save(newValue, forKey: "isDarkMode")
        }
    }

    var appLanguage: AppLanguage {
        get {
            access(keyPath: \.appLanguage)
            return _appLanguage
        }
        set {
            withMutation(keyPath: \.appLanguage) { _appLanguage = newValue }
            save(newValue.rawValue, forKey: "appLanguage")
        }
    }

    // MARK: - Computed

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
