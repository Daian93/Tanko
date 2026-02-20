//
//  MainTabView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 21/1/26.
//

import SwiftData
import SwiftUI

extension View {
    var isPhone: Bool {
        #if os(iOS)
            return UIDevice.current.userInterfaceIdiom == .phone
        #else
            return false
        #endif
    }
}

struct MainTabView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(UserMangaCollectionViewModel.self) private var userCollectionVM

    #if os(iOS)
        @Environment(\.horizontalSizeClass) private var horizontalSizeClass
        
        private var isIPad: Bool {
            UIDevice.current.userInterfaceIdiom == .pad
        }
    #endif

    var body: some View {
        TabView {
            Tab("tab.mangas", systemImage: "book.fill") {
                #if os(macOS)
                    ContentViewiPad()
                #else
                    if isIPad {
                        ContentViewiPad()
                    } else {
                        ContentView()
                    }
                #endif
            }

            Tab("tab.collection", systemImage: "books.vertical.fill") {
                CollectionView()
            }

            Tab("tab.profile", systemImage: "person.fill") {
                ProfileView()
            }

            Tab("tab.search", systemImage: "magnifyingglass", role: .search) {
                #if os(macOS)
                    SearchViewiPad()
                #else
                    if isIPad {
                        SearchViewiPad()
                    } else {
                        SearchView()
                    }
                #endif
            }
        }
        #if os(iOS)
            .tabBarMinimizeBehavior(.onScrollDown)
            .tabViewStyle(.sidebarAdaptable)
            .defaultAdaptableTabBarPlacement(.tabBar)
        #endif
    }
}

#Preview {
    MainTabView()
        .withPreviewEnvironment()
}
