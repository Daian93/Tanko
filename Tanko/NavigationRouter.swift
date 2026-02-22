//
//  NavigationRouter.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 21/2/26.
//

import SwiftUI

@MainActor
@Observable
final class NavigationRouter {
    static let shared = NavigationRouter()
    
    var selectedTabTag: Int = 0
    
    var collectionPath = NavigationPath()
    
    private init() {}
    
    func navigateToMangaDetail(_ manga: UserManga) {
        selectedTabTag = 1
        
        collectionPath = NavigationPath()
        
        Task {
            try? await Task.sleep(for: .milliseconds(100))
            collectionPath.append(manga)
        }
    }
}
