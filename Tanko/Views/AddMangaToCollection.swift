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
    @State private var readingVolumeText: String = "0"
    @FocusState private var isTextFieldFocused: Bool

    private var totalVolumes: Int {
        max(manga.volumes ?? 0, 0)
    }
    
    private var maxVolume: Int {
        totalVolumes > 0 ? totalVolumes : 999
    }
    
    private var isCompleteCollection: Bool {
        guard totalVolumes > 0 else { return false }
        return volumesOwned.count == totalVolumes
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Tomo actual", systemImage: "book.closed.fill")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        HStack(spacing: 12) {
                            // Botón -
                            Button {
                                decrementReading()
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .font(.system(size: 32))
                                    .foregroundStyle(readingVolume > 0 ? Color.red : Color.gray)
                            }
                            .disabled(readingVolume <= 0)
                            
                            TextField("0", text: $readingVolumeText)
                                .keyboardType(.numberPad)
                                .textFieldStyle(.roundedBorder)
                                .multilineTextAlignment(.center)
                                .font(.title2.bold())
                                .focused($isTextFieldFocused)
                                .onChange(of: readingVolumeText) { _, newValue in
                                    updateReadingFromText(newValue)
                                }
                                .frame(maxWidth: 100)
                            
                            // Botón +
                            Button {
                                incrementReading()
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 32))
                                    .foregroundStyle(readingVolume < maxVolume ? Color.green : Color.gray)
                            }
                            .disabled(readingVolume >= maxVolume)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.vertical, 8)
                } header: {
                    Text("Progreso de lectura")
                } footer: {
                    if totalVolumes > 0 {
                        Text("De un total de \(totalVolumes) tomos.")
                    } else {
                        Text("Total de volúmenes desconocido.")
                    }
                }

                if totalVolumes > 0 {
                    Section {
                        HStack(spacing: 10) {
                            Button {
                                selectAllVolumes()
                            } label: {
                                Label("Todos", systemImage: "checkmark.circle.fill")
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                            .tint(.green)
                            
                            Button {
                                clearAllVolumes()
                            } label: {
                                Label("Ninguno", systemImage: "xmark.circle.fill")
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                            .tint(.red)
                            
                            Button {
                                invertSelection()
                            } label: {
                                Label("Invertir", systemImage: "arrow.triangle.2.circlepath")
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                            .tint(.blue)
                        }
                        .padding(.vertical, 4)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], spacing: 10) {
                            ForEach(1...totalVolumes, id: \.self) { number in
                                let owned = volumesOwned.contains(number)
                                Button {
                                    toggleVolume(number)
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
                    } header: {
                        Text("Tomos en estantería")
                    } footer: {
                        Text("\(volumesOwned.count) de \(totalVolumes) tomos seleccionados")
                    }
                }


                if totalVolumes > 0 {
                    Section {
                        HStack {
                            Label("Estado de la colección", systemImage: "checkmark.seal.fill")
                                .foregroundStyle(.secondary)
                            Spacer()
                            if isCompleteCollection {
                                Text("Completa")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.green)
                            } else {
                                Text("Incompleta")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    } footer: {
                        if isCompleteCollection {
                            Text("Tienes todos los \(totalVolumes) tomos en tu estantería.")
                        } else {
                            Text("Te faltan \(totalVolumes - volumesOwned.count) tomos para completar la colección.")
                        }
                    }
                }
            }
            .onTapGesture {
                isTextFieldFocused = false
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
                    Button("Añadir") {
                        Task {
                            await userMangaCollectionVM.add(
                                manga: manga,
                                volumesOwned: Array(volumesOwned).sorted(),
                                readingVolume: readingVolume == 0 ? nil : readingVolume,
                                completeCollection: isCompleteCollection
                            )
                            dismiss()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func incrementReading() {
        if readingVolume < maxVolume {
            readingVolume += 1
            readingVolumeText = "\(readingVolume)"
        }
    }
    
    private func decrementReading() {
        if readingVolume > 0 {
            readingVolume -= 1
            readingVolumeText = "\(readingVolume)"
        }
    }
    
    private func updateReadingFromText(_ text: String) {
        let filtered = text.filter { $0.isNumber }
        
        if let value = Int(filtered) {
            readingVolume = min(value, maxVolume)
            if value > maxVolume {
                readingVolumeText = "\(maxVolume)"
            }
        } else if filtered.isEmpty {
            readingVolume = 0
            readingVolumeText = "0"
        }
    }
    
    private func toggleVolume(_ number: Int) {
        if volumesOwned.contains(number) {
            volumesOwned.remove(number)
        } else {
            volumesOwned.insert(number)
        }
    }
    
    private func selectAllVolumes() {
        volumesOwned = Set(1...totalVolumes)
    }
    
    private func clearAllVolumes() {
        volumesOwned.removeAll()
    }
    
    private func invertSelection() {
        let allVolumes = Set(1...totalVolumes)
        volumesOwned = allVolumes.subtracting(volumesOwned)
    }
}

#Preview {
    AddMangaToCollectionView(manga: .test)
        .withPreviewEnvironment()
}
