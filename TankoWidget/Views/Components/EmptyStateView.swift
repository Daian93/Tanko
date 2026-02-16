//
//  EmptyStateView.swift
//  TankoWidget
//
//  Created by Diana Rammal Sansón on 16/2/26.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "books.vertical.fill")
                .font(.system(size: 40))
                .foregroundStyle(.white.opacity(0.4))
            
            VStack(spacing: 4) {
                Text("Sin mangas leyendo")
                    .font(.subheadline.bold())
                    .foregroundStyle(.white.opacity(0.9))
                
                Text("Añade mangas a tu colección")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.6))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
