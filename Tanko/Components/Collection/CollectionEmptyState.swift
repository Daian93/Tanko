//
//  CollectionEmptyState.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/2/26.
//

import SwiftUI

struct CollectionEmptyState: View {
    let filter: UserMangaCollectionViewModel.CollectionFilter

    private var message: String {
        switch filter {
        case .todo:        return "Aún no tienes mangas en tu colección.\nBusca uno y añádelo."
        case .porEmpezar:  return "No tienes mangas pendientes de empezar."
        case .leyendo:     return "No estás leyendo ningún manga ahora mismo."
        case .leidos:      return "Aún no has terminado de leer ningún manga."
        case .completados: return "No tienes ninguna colección completa."
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
                .foregroundStyle(.tankoPrimary.opacity(0.4))

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 40)
    }
}

#Preview {
    CollectionEmptyState(filter: .todo)
}
