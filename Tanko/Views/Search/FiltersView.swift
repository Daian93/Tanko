//
//  FiltersView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 3/2/26.
//

import SwiftUI

struct FiltersView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var filtersViewModel: FiltersViewModel
    let onApply: (CustomSearchDTO) -> Void

    var body: some View {
        NavigationStack {
            Form {
                FiltersSidebarContent(filtersVM: filtersViewModel)

                if filtersViewModel.hasActiveFilters {
                    Section {
                        Button(role: .destructive) {
                            filtersViewModel.resetAllFilters()
                        } label: {
                            Text("search.clean.all")
                        }
                    }
                }
            }
            .navigationTitle("search.filters")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("button.cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("button.apply") {
                        let dto = filtersViewModel.createSearchDTO()
                        onApply(dto)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    FiltersView(filtersViewModel: FiltersViewModel()) { dto in
        print("Filtros aplicados: \(dto)")
    }
    .withPreviewEnvironment()
}
