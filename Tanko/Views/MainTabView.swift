//
//  MainTabView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 21/1/26.
//

import SwiftUI

@MainActor let isiPhone = UIDevice.current.userInterfaceIdiom == .phone

struct MainTabView: View {
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
        .environment(MangasViewModel())
}
