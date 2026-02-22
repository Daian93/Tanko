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

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 40) {
                ForEach(mangas) { manga in
                    NavigationLink(value: manga) {
                        MangaCard(manga: manga, namespace: namespace)
                            .frame(width: 280)
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
    NavigationStack {
        MangaCarousel(
            mangas: [.test],
            namespace: Namespace().wrappedValue
        )
    }
    .withPreviewEnvironment()
}
