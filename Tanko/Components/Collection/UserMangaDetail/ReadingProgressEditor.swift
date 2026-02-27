//
//  ReadingProgressEditor.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 17/2/26.
//

import SwiftUI

// MARK: - Reading Progress Editor

struct ReadingProgressEditor: View {
    @Binding var readingVolume: Int
    let maxVolume: Int
    @FocusState.Binding var isTextFieldFocused: Bool

    var body: some View {
        HStack(spacing: 12) {
            Spacer()

            // Button -
            Button {
                isTextFieldFocused = false
                decrementReading()
            } label: {
                Image(systemName: "minus.circle.fill")
                    #if os(macOS)
                        .font(.system(size: 24))
                    #else
                        .font(.system(size: 32))
                    #endif
                    .foregroundStyle(readingVolume > 0 ? Color.red : Color.gray)
            }
            .buttonStyle(.plain)
            .disabled(readingVolume <= 0)

            // TextField with number formatting and keyboard type
            TextField(
                "",
                value: $readingVolume,
                format: .number,
                prompt: Text("0").foregroundStyle(.tankoSecondary)
            )
            #if os(iOS)
                .keyboardTypeCompatible(.numberPad)
            #endif
            .multilineTextAlignment(.center)
            .font(.title2.bold())
            .frame(width: 80)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .focused($isTextFieldFocused)
            .onChange(of: readingVolume) { _, newValue in
                readingVolume = min(max(newValue, 0), maxVolume)
            }
            #if os(iOS)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("reading.done") {
                            isTextFieldFocused = false
                        }
                        .fontWeight(.semibold)
                    }
                }
            #endif

            // Button +
            Button {
                isTextFieldFocused = false
                incrementReading()
            } label: {
                Image(systemName: "plus.circle.fill")
                    #if os(macOS)
                        .font(.system(size: 24))
                    #else
                        .font(.system(size: 32))
                    #endif
                    .foregroundStyle(
                        readingVolume < maxVolume ? Color.green : Color.gray
                    )
            }
            .buttonStyle(.plain)
            .disabled(readingVolume >= maxVolume)

            Spacer()
        }
        .padding(.vertical, 8)
    }

    // MARK: - Helper Methods
    private func incrementReading() {
        guard readingVolume < maxVolume else { return }
        readingVolume += 1
    }

    private func decrementReading() {
        guard readingVolume > 0 else { return }
        readingVolume -= 1
    }
}

#Preview {
    @Previewable @State var readingVolume: Int = 3
    @Previewable @FocusState var isTextFieldFocused: Bool

    ReadingProgressEditor(
        readingVolume: $readingVolume,
        maxVolume: 10,
        isTextFieldFocused: $isTextFieldFocused
    )
    .padding()
}
