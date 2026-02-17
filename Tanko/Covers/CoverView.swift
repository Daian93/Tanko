//
//  CoverView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 24/1/26.
//

import SwiftUI

struct CoverView: View {
    let cover: URL?
    var big: Bool
    let namespace: Namespace.ID

    @State private var coverVM = CoverVM()

    init(cover: URL?, namespace: Namespace.ID, big: Bool = false) {
        self.cover = cover
        self.namespace = namespace
        self.big = big
    }

    var body: some View {
        Group {
            if !big {
                if let image = coverVM.image {
                    #if canImport(UIKit)
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 11))
                            .matchedTransitionSource(
                                id: cover?.lastPathComponent
                                    ?? UUID().uuidString,
                                in: namespace
                            )
                    #elseif canImport(AppKit)
                        Image(nsImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 11))
                            .matchedTransitionSource(
                                id: cover?.lastPathComponent
                                    ?? UUID().uuidString,
                                in: namespace
                            )
                    #endif
                } else {
                    placeholder
                        .matchedTransitionSource(
                            id: cover?.lastPathComponent ?? UUID().uuidString,
                            in: namespace
                        )
                }
            } else {
                if let image = coverVM.image {
                    #if canImport(UIKit)
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 160)
                            .clipShape(RoundedRectangle(cornerRadius: 11))
                            .navigationTransition(
                                .zoom(
                                    sourceID: cover?.lastPathComponent
                                        ?? UUID().uuidString,
                                    in: namespace
                                )
                            )
                    #elseif canImport(AppKit)
                        Image(nsImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 160)
                            .clipShape(RoundedRectangle(cornerRadius: 11))
                    #endif
                } else {
                    #if canImport(UIKit)
                        placeholder
                            .navigationTransition(
                                .zoom(
                                    sourceID: cover?.lastPathComponent
                                        ?? UUID().uuidString,
                                    in: namespace
                                )
                            )
                    #elseif canImport(AppKit)
                        placeholder
                    #endif
                }
            }
        }
        .onAppear {
            coverVM.getImage(cover: cover)
        }
    }

    private var placeholder: some View {
        let width = big ? 120.0 : 70.0
        let height = big ? 160.0 : 100.0

        return Image(systemName: "book")
            .resizable()
            .scaledToFit()
            .frame(width: width * 0.5, height: height * 0.5)
            .foregroundStyle(.white.opacity(0.8))
            .frame(width: width, height: height)
            .background(
                .gray.opacity(0.3),
                in: RoundedRectangle(cornerRadius: 11)
            )
    }

}

#Preview {
    @Previewable @Namespace var namespace
    CoverView(
        cover: URL(
            string: "https://cdn.myanimelist.net/images/manga/3/258224l.jpg"
        ),
        namespace: namespace,
    )
}
