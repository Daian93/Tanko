//
//  TankoApp.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/12/25.
//

import SwiftUI

@main
struct TankoApp: App {
    @State private var mangasVM = MangaViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(mangasVM)
        }
    }
}
