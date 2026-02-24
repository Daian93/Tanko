//
//  NavigationRouter.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 21/2/26.
//

import SwiftUI

extension NSNotification.Name {
    static let navigateToManga = NSNotification.Name("navigateToManga")
}

@Observable
@MainActor
final class NavigationRouter {
    static let shared = NavigationRouter()

    var selectedTabTag: Int = 0
    var pendingSearchFilter: CustomSearchDTO? = nil

    private init() {}

    // MARK: - Deep Link Logic

    func handleDeepLink(_ url: URL, userMangas: [UserManga]) {
        guard url.scheme == "tanko", url.host == "manga" else { return }
        guard let idString = url.pathComponents.last,
              let mangaID = Int(idString) else { return }
        if let manga = userMangas.first(where: { $0.mangaID == mangaID }) {
            navigateToMangaDetail(manga)
        }
    }

    func navigateToMangaDetail(_ manga: UserManga) {
        selectedTabTag = 1
        Task {
            try? await Task.sleep(for: .milliseconds(150))
            NotificationCenter.default.post(
                name: .navigateToManga,
                object: manga
            )
        }
    }

    // MARK: - Search Navigation

    func navigateToSearch(filter: CustomSearchDTO) {
        pendingSearchFilter = nil

        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(32))

            selectedTabTag = 3

            #if os(macOS)
            try? await Task.sleep(for: .milliseconds(300))
            #else
            try? await Task.sleep(for: .milliseconds(200))
            #endif

            pendingSearchFilter = filter
        }
    }
}
