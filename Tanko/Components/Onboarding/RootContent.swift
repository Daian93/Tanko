//
//  RootContent.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 25/2/26.
//

import SwiftUI

struct RootContent: View {
    let vm: UserMangaCollectionViewModel
    let showLoadingOverlay: Bool
    let isAuthenticated: Bool

    var body: some View {
        if showLoadingOverlay {
            RootLoading(isAuthenticated: isAuthenticated)
        } else {
            MainTabView()
                .environment(vm)
                .transition(.opacity)
        }
    }
}

#Preview {
    RootContent(
        vm: PreviewHelper.makeCollectionVM(),
        showLoadingOverlay: false,
        isAuthenticated: false
    )
    .withPreviewEnvironment()
}

