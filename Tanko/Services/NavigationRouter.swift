//
//  NavigationRouter.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 21/2/26.
//

import SwiftUI

@Observable
@MainActor
final class NavigationRouter {
    static let shared = NavigationRouter()
    var selectedTabTag: Int = 0
    var collectionPath = NavigationPath()
    
    private init() {}
    
    // MARK: - Deep Link Logic
    
    // Handle deep links in the format: tanko://manga/{mangaID}
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
        collectionPath = NavigationPath()
        
        Task {
            try? await Task.sleep(for: .milliseconds(150))
            collectionPath.append(manga)
        }
    }
}

