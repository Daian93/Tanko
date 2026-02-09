//
//  AddMangaToCollection.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 8/2/26.
//

import SwiftUI
import SwiftData

struct AddMangaToCollectionView: View {
    let manga: Manga
    @Environment(\.dismiss) private var dismiss
    @Environment(UserMangaCollectionViewModel.self) private var userMangaCollectionVM

    @State private var volumesOwned: Set<Int> = []
    @State private var readingVolume: Int = 0
    @State private var completeCollection = false

    private var totalVolumes: Int {
        max(manga.volumes ?? 0, 0)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Progreso de lectura") {
                    Stepper(
                        "Tomo actual: \(readingVolume)",
                        value: $readingVolume,
                        in: 0...(totalVolumes > 0 ? totalVolumes : 999)
                    )
                }

                if totalVolumes > 0 {
                    Section("Tomos en estantería") {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))]) {
                            ForEach(1...totalVolumes, id: \.self) { number in
                                let owned = volumesOwned.contains(number)
                                Button {
                                    if owned { volumesOwned.remove(number) }
                                    else { volumesOwned.insert(number) }
                                } label: {
                                    Text("\(number)")
                                        .frame(width: 44, height: 44)
                                        .background(owned ? Color.green : Color.gray.opacity(0.2))
                                        .foregroundStyle(owned ? .white : .primary)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }

                Section {
                    Toggle("Colección completa", isOn: $completeCollection)
                }
            }
            .navigationTitle("Añadir a colección")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Agregar") {
                        Task {
                            await userMangaCollectionVM.addToCollection(
                                manga: manga,
                                volumesOwned: Array(volumesOwned).sorted(),
                                readingVolume: readingVolume == 0 ? nil : readingVolume,
                                completeCollection: completeCollection
                            )
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}
