//
//  MangaCarousel.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 22/2/26.
//

import SwiftUI

struct MangaCarousel: View {
    let mangas: [Manga]
    let namespace: Namespace.ID

    private let cardWidth: CGFloat = 280

    var body: some View {

        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 40) {
                ForEach(Array(mangas.enumerated()), id: \.element.id) {
                    index,
                    manga in
                    // Use transition with zoom for all mangas, but without zoom for the best mangas
                    NavigationLink(
                        value: MangaNavigation.withoutTransition(manga)
                    ) {
                        MangaCard(manga: manga)
                            .frame(width: cardWidth)
                    }
                    .buttonStyle(.plain)
                }
            }
            .scrollTargetLayout()
        }
        .defaultScrollAnchor(.center)
        .scrollTargetBehavior(.viewAligned)
        .scrollClipDisabled()
        .contentMargins(.horizontal, 80, for: .scrollContent)
    }
}

#Preview {
    @Previewable @Namespace var namespace
    
    NavigationStack {
        VStack(alignment: .leading, spacing: 20) {
            Spacer()
            
            MangaCarousel(
                mangas: [.test, .test2],
                namespace: namespace
            )
            .frame(height: 240)
            
            Spacer()
        }
        .navigationDestination(for: MangaNavigation.self) { nav in
            MangaDetailView(manga: nav.manga, namespace: nil)
        }
    }
    .withPreviewEnvironment()
}
