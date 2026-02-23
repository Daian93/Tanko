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
        case .todo:
            "collection.empty.todo"
        case .porEmpezar:
            "collection.empty.to_start"
        case .leyendo:
            "collection.empty.reading"
        case .leidos:
            "collection.empty.read"
        case .completados:
            "collection.empty.completed"
        }
    }

    private var icon: String {
        switch filter {
        case .todo:        return "books.vertical"
        case .porEmpezar:  return "bookmark"
        case .leyendo:     return "book"
        case .leidos:      return "book.closed"
        case .completados: return "checkmark.seal"
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
    CollectionEmptyState(filter: .todo)
}
