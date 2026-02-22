//
//  MangaLoadingView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 22/2/26.
//

import SwiftUI

struct MangaLoadingView: View {
    var body: some View {
        ProgressView("content.loading")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.tankoBackground)
    }
}

#Preview("Loading") {
    MangaLoadingView()
}
