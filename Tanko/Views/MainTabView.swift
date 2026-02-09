//
//  MainTabView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 21/1/26.
//

import SwiftUI
import SwiftData

@MainActor let isiPhone = UIDevice.current.userInterfaceIdiom == .phone

struct MainTabView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(UserMangaCollectionViewModel.self) private var userMangaCollectionViewModel
    
    var body: some View {
        TabView {
            Tab("tab.mangas", systemImage: "book.fill") {
                if !isiPhone {
                    ContentViewiPad()
                } else {
                    ContentView()
                }
            }

            Tab("tab.profile", systemImage: "person.fill") {
                ProfileView()
            }

            Tab("tab.search", systemImage: "magnifyingglass", role: .search) {
                SearchView()
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .tabViewStyle(.sidebarAdaptable)
        .defaultAdaptableTabBarPlacement(.tabBar)
    }
}

#Preview {
    MainTabView()
        .environment(MangaViewModel())
        .environment(UserMangaCollectionViewModel())
        .modelContainer(for: [UserManga.self])
}
