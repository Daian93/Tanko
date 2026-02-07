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
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 11))
                        .matchedTransitionSource(id: cover?.lastPathComponent ?? UUID().uuidString, in: namespace)
                } else {
                    placeholder
                        .matchedTransitionSource(id: cover?.lastPathComponent ?? UUID().uuidString, in: namespace)
                }
            } else {
                if let image = coverVM.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 160)
                        .clipShape(RoundedRectangle(cornerRadius: 11))
                        .navigationTransition(.zoom(sourceID: cover?.lastPathComponent ?? UUID().uuidString, in: namespace))
                } else {
                    placeholder
                        .navigationTransition(.zoom(sourceID: cover?.lastPathComponent ?? UUID().uuidString, in: namespace))
                }
            }
        }
        .onAppear {
            coverVM.getImage(cover: cover)
        }
    }
    
    private var placeholder: some View {
        Image(systemName: "book")
            .font(.largeTitle)
            .padding(.horizontal, 10)
            .padding(.vertical, 30)
            .background(.gray.opacity(0.3), in: .rect(cornerRadius: 11))
    }
}

#Preview {
    @Previewable @Namespace var namespace
    CoverView(
        cover: URL(string: "https://cdn.myanimelist.net/images/manga/3/258224l.jpg"),
        namespace: namespace,
        big: true
    )
}

