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
    @State private var mangasVM = MangaViewModel()
    @State private var userMangaCollectionVM = UserMangaCollectionViewModel()

    @State private var session = SessionManager()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(session)
                .environment(mangasVM)
                .environment(userMangaCollectionVM)
        }
        .modelContainer(for: [UserManga.self])
    }
}
