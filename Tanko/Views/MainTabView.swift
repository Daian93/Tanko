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
    // Ya no necesitas declarar la VM aquí si no la usas en esta vista,
    // pero si la necesitas, se queda así:
    @Environment(UserMangaCollectionViewModel.self) private var userCollectionVM
    
    var body: some View {
        TabView {
            Tab("tab.mangas", systemImage: "book.fill") {
                if !isiPhone {
                    ContentViewiPad()
                } else {
                    ContentView() // ✅ Ahora esto ya funciona
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

