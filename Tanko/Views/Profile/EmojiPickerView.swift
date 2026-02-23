//
//  EmojiPickerView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 11/2/26.
//

import SwiftUI

struct EmojiPickerView: View {
    @Binding var selectedEmoji: String

    private let emojis = [
        "🙂", "😎", "🤓", "😇", "🥳", "🔖", "📚", "📖", "👺", "🇯🇵", "🧚🏼‍♀️", "🐨", "🐼", "🌊", "🩵",
        "💕", "👾", "🐉", "🍀", "🔥", "🌸", "🌞", "🌙", "⭐️",
    ]

    private let columns = [GridItem(.adaptive(minimum: 110))]

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(emojis, id: \.self) { emoji in
                        Button {
                            selectedEmoji = emoji
                            dismiss()
                        } label: {
                            Text(emoji)
                                .font(.system(size: 40))
                                .frame(width: 50, height: 50)
                                .background(
                                    selectedEmoji == emoji
                                        ? Color.blue.opacity(0.2) : Color.clear
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("emoji.select")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("button.close") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    EmojiPickerView(selectedEmoji: .constant("🌸"))
}
