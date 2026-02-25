//
//  CollectionEmptyState.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/2/26.
//

import SwiftUI

struct CollectionEmptyState: View {
    let filter: UserMangaCollectionViewModel.CollectionFilter

    private var message: LocalizedStringKey {
        switch filter {
        case .all:
            "collection.empty.todo"
        case .toRead:
            "collection.empty.to_start"
        case .reading:
            "collection.empty.reading"
        case .read:
            "collection.empty.read"
        case .complete:
            "collection.empty.completed"
        }
    }

    private var icon: String {
        switch filter {
        case .all:        return "books.vertical"
        case .toRead:  return "bookmark"
        case .reading:     return "book"
        case .read:      return "book.closed"
        case .complete: return "checkmark.seal"
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 50))
                .foregroundStyle(.tankoPrimary.opacity(0.8))

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.tankoSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 40)
    }
}

#Preview {
    CollectionEmptyState(filter: .all)
}
