//
//  AuthorHeader.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/2/26.
//

import SwiftUI

struct AuthorHeader: View {
    let author: Author
    var large: Bool = false  // false = iPhone style, true = iPad style

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: large ? 12 : 4) {
                Text(author.fullName)
                    .font(large ? .largeTitle : .title)
                    .fontWeight(.bold)
                    .tracking(-0.5)

                HStack(spacing: large ? 8 : 6) {
                    Image(systemName: author.role.icon)
                        .font(large ? .caption : .caption2)
                    Text(author.role.localized)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .textCase(.uppercase)
                }
                .padding(.horizontal, large ? 14 : 10)
                .padding(.vertical, large ? 8 : 4)
                .foregroundStyle(.tankoPrimary)
                .background(.surface)
                .clipShape(Capsule())
            }
            Spacer()
        }
        .padding(large ? 30 : 16)
        #if os(macOS)
            .background(.tankoSecondary.opacity(0.3))
        #else
            .background(.surface)
        #endif
        .clipShape(RoundedRectangle(cornerRadius: large ? 24 : 20))
        .shadow(
            color: .black.opacity(large ? 0.25 : 0.3),
            radius: large ? 8 : 5,
            y: large ? 3 : 2
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        AuthorHeader(author: .test, large: false)
        AuthorHeader(author: .test, large: true)
    }
    .padding()
}
