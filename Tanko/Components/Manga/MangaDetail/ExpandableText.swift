//
//  ExpandableText.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/2/26.
//

import SwiftUI

struct ExpandableText: View {
    let title: LocalizedStringKey
    let text: String
    let lineLimit: Int
    let minCharCount: Int

    @State private var isExpanded = false

    init(
        title: LocalizedStringKey,
        text: String,
        lineLimit: Int = 4,
        minCharCount: Int = 200
    ) {
        self.title = title
        self.text = text
        self.lineLimit = lineLimit
        self.minCharCount = minCharCount
    }

    private var shouldShowToggle: Bool {
        text.count > minCharCount
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)

            VStack(alignment: .leading) {
                Text(text)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .lineLimit(isExpanded ? nil : lineLimit)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .overlay(alignment: .bottom) {
                if !isExpanded && shouldShowToggle {
                    LinearGradient(
                        colors: [.clear, Color(.tankoBackground)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 32)
                    .allowsHitTesting(false)
                }
            }
            .animation(.easeInOut(duration: 0.25), value: isExpanded)

            if shouldShowToggle {
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        isExpanded.toggle()
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(isExpanded ? "section.showLess" : "section.showMore")
                            .font(.caption)
                            .fontWeight(.semibold)

                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.caption2)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal)
        .background(.tankoBackground)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 20) {
            ExpandableText(
                title: "section.synopsis",
                text: String(repeating: "Este es un texto largo de prueba. ", count: 20)
            )
            ExpandableText(
                title: "section.background",
                text: "Texto corto."
            )
        }
    }
}
