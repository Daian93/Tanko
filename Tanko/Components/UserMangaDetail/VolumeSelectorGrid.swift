//
//  VolumeSelectorGrid.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 17/2/26.
//

import SwiftUI

struct VolumeSelectionGrid: View {
    @Binding var volumesOwned: Set<Int>
    let totalVolumes: Int
    
    private let columns = [GridItem(.adaptive(minimum: 45))]
    
    var body: some View {
        VStack(spacing: 12) {
            // Fast actions buttons
            HStack(spacing: 8) {
                Button {
                    selectAllVolumes()
                } label: {
                    Label("volume.all", systemImage: "checkmark.circle.fill")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(.green)
                
                Button {
                    clearAllVolumes()
                } label: {
                    Label("volume.none", systemImage: "xmark.circle.fill")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(.red)
                
                Button {
                    invertSelection()
                } label: {
                    Label("volume.invert", systemImage: "arrow.triangle.2.circlepath")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(.blue)
            }
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
    
    // Volume grid view
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
    
    // MARK: - Actions
    // Toggle a single volume's owned status
    private func toggleVolume(_ number: Int) {
        if volumesOwned.contains(number) {
            volumesOwned.remove(number)
        } else {
            volumesOwned.insert(number)
        }
    }
    
    // Select all volumes as owned
    private func selectAllVolumes() {
        volumesOwned = Set(1...totalVolumes)
    }
    
    // Deselect all volumes
    private func clearAllVolumes() {
        volumesOwned.removeAll()
    }
    
    // Invert the selection of owned volumes
    private func invertSelection() {
        let allVolumes = Set(1...totalVolumes)
        volumesOwned = allVolumes.subtracting(volumesOwned)
    }
}

