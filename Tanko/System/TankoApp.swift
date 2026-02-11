//
//  TankoApp.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/12/25.
//

import SwiftData
import SwiftUI

@main
struct TankoApp: App {
    @State private var session = SessionManager()
    @State private var mangasVM = MangaViewModel()
    @State private var settings = AppSettings()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(session)
                .environment(mangasVM)
                .environment(settings)
                .preferredColorScheme(settings.isDarkMode ? .dark : .light)
        }
        .modelContainer(for: [UserManga.self])
    }
}


