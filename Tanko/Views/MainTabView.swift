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
    @Query private var allUserMangas: [UserManga]

    #if os(iOS)
        @Environment(\.horizontalSizeClass) private var horizontalSizeClass

        private var isIPad: Bool {
            UIDevice.current.userInterfaceIdiom == .pad
        }
    #endif

    var body: some View {
        TabView(selection: $router.selectedTabTag) {
            Tab("tab.mangas", systemImage: "book.fill", value: 0) {
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
            handleDeepLink(url)
        }
    }

    private func handleDeepLink(_ url: URL) {
        guard url.scheme == "tanko",
            url.host == "manga",
            let idString = url.pathComponents.last,
            let mangaID = Int(idString)
        else { return }

        if let manga = allUserMangas.first(where: { $0.mangaID == mangaID }) {
            router.navigateToMangaDetail(manga)
        }
    }
}

#Preview {
    MainTabView()
        .withPreviewEnvironment()
}
