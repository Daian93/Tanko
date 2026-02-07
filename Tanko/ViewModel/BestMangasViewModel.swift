//
//  BestMangasViewModel.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 24/1/26.
//

import SwiftUI

enum BestMangasViewState {
    case loading
    case loaded
    case empty
}

@Observable
@MainActor
final class BestMangasViewModel {

    private let repository: NetworkRepository

    var mangas: [Manga] = []
    var state: BestMangasViewState = .loading

    var showError = false
    var errorMsg = ""

    init(repository: NetworkRepository = Network()) {
        self.repository = repository
    }

    func getBestMangas() async {
        guard mangas.isEmpty else { return }

        state = .loading

        do {
            let page = try await repository.getBestMangas(
                page: NetworkConstants.defaultPage,
                per: NetworkConstants.defaultPerPage - 1
            )

            mangas = page.items
            state = mangas.isEmpty ? .empty : .loaded

        } catch {
            errorMsg = error.localizedDescription
            showError = true
            state = .empty
        }
    }

    func refresh() async {
        mangas.removeAll()
        state = .loading
        await getBestMangas()
    }
}
