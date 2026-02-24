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

    @State private var router = NavigationRouter.shared
    @State private var selectedTab: Int = 0

    @Query private var allUserMangas: [UserManga]

    #if os(iOS)
        @Environment(\.horizontalSizeClass) private var horizontalSizeClass

        private var isIPad: Bool {
            UIDevice.current.userInterfaceIdiom == .pad
        }
    #endif

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("tab.mangas", systemImage: "book.closed.fill", value: 0) {
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

            Tab("tab.collection", systemImage: "books.vertical.fill", value: 1)
            {
                CollectionView()
            }

            Tab("tab.profile", systemImage: "person.fill", value: 2) {
                ProfileView()
            }

            Tab(
                "tab.search",
                systemImage: "magnifyingglass",
                value: 3,
                role: .search
            ) {
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
        .onOpenURL { url in
            router.handleDeepLink(url, userMangas: allUserMangas)
        }
        .onChange(of: router.selectedTabTag) { _, newTab in
            Task { @MainActor in
                await Task.yield()
                selectedTab = newTab
            }
        }
        .onChange(of: selectedTab) { _, newTab in
            if router.selectedTabTag != newTab {
                router.selectedTabTag = newTab
            }
        }
    }
}

#Preview {
    MainTabView()
        .withPreviewEnvironment()
}
