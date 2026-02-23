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

    init() {
        self.profileEmoji = UserDefaults.standard.string(forKey: "profileEmoji") ?? "🙂"
        self.userName = UserDefaults.standard.string(forKey: "profileUserName") ?? ""
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    }

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
}
