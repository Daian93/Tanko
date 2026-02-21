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
    @State private var settings = AppSettings()
    @State private var mangasVM = MangaViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(session)
                .environment(mangasVM)
                .environment(settings)
                .preferredColorScheme(settings.isDarkMode ? .dark : .light)
                #if os(macOS)
                    .buttonStyle(.plain)
                #endif
        }
        .modelContainer(for: [UserManga.self, PendingOperation.self])
    }
}
