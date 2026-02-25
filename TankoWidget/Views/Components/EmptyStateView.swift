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
                Text("widget.no.manga")
                    .font(.subheadline.bold())
                    .foregroundStyle(.white.opacity(0.9))

                Text("widget.add.manga")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.6))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
