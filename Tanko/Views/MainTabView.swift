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
    @Environment(UserMangaCollectionViewModel.self) private var userCollectionVM
    
    var body: some View {
        TabView {
            Tab("tab.mangas", systemImage: "book.fill") {
                if !isiPhone {
                    ContentViewiPad()
                } else {
                    ContentView()
                }
            }
            
            Tab("tab.collection", systemImage: "books.vertical.fill") {
                CollectionView()
            }

            Tab("tab.profile", systemImage: "person.fill") {
                ProfileView()
            }

            Tab("tab.search", systemImage: "magnifyingglass", role: .search) {
                if !isiPhone {
                    SearchViewiPad()
                } else {
                    SearchView()
                }
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .tabViewStyle(.sidebarAdaptable)
        .defaultAdaptableTabBarPlacement(.tabBar)
    }
}

#Preview {
    MainTabView()
        .withPreviewEnvironment()
}
