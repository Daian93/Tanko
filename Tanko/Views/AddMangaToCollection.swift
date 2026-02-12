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
                // 📖 Sección de Progreso
                Section {
                    Stepper(value: $readingVolume, in: 0...(totalVolumes > 0 ? totalVolumes : 999)) {
                        HStack {
                            Label("Tomo actual", systemImage: "book.closed.fill")
                            Spacer()
                            Text("\(readingVolume)")
                                .fontWeight(.bold)
                                .foregroundStyle(.blue)
                        }
                    }
                } header: {
                    Text("Progreso de lectura")
                } footer: {
                    if totalVolumes > 0 {
                        Text("De un total de \(totalVolumes) tomos.")
                    }
                }

                // 📚 Sección de Tomos físicos
                if totalVolumes > 0 {
                    Section("Tomos en estantería") {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], spacing: 10) {
                            ForEach(1...totalVolumes, id: \.self) { number in
                                let owned = volumesOwned.contains(number)
                                Button {
                                    if owned {
                                        volumesOwned.remove(number)
                                    } else {
                                        volumesOwned.insert(number)
                                    }
                                } label: {
                                    Text("\(number)")
                                        .font(.caption.bold())
                                        .frame(width: 44, height: 44)
                                        .background(owned ? Color.green : Color.gray.opacity(0.2))
                                        .foregroundStyle(owned ? .white : .primary)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }

                // ✅ Estado de la colección
                Section {
                    Toggle(isOn: $completeCollection) {
                        Label("Colección completa", systemImage: "checkmark.seal.fill")
                    }
                    .tint(.green)
                }
            }
            .navigationTitle("Añadir a colección")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    // En AddMangaToCollectionView
                    Button("Añadir") {
                        Task {
                            await userMangaCollectionVM.add(
                                manga: manga, // Objeto Manga (API)
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

#Preview {
    AddMangaToCollectionView(manga: .test)
        .withPreviewEnvironment()
}
