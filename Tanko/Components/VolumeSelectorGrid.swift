//
//  VolumeSelectorGrid.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 17/2/26.
//

import SwiftUI

// MARK: - Volume Selection Grid

struct VolumeSelectionGrid: View {
    @Binding var volumesOwned: Set<Int>
    let totalVolumes: Int
    
    private let columns = [GridItem(.adaptive(minimum: 45))]
    
    var body: some View {
        VStack(spacing: 12) {
            // Botones de acción rápida
            HStack(spacing: 8) {
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
            
            // Grid de volúmenes
            #if os(macOS)
            ScrollView {
                volumeGrid
                    .padding(.vertical, 8)
            }
            .frame(maxHeight: 300)
            #else
            volumeGrid
                .padding(.vertical, 8)
            #endif
        }
    }
    
    private var volumeGrid: some View {
        LazyVGrid(columns: columns, spacing: 10) {
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

