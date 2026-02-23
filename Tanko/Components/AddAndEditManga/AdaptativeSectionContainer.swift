//
//  AdaptativeSectionContainer.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/2/26.
//

import SwiftUI

enum AdaptiveSectionStyle {
    case form
    case card
}

struct AdaptiveSectionContainer<Content: View>: View {

    let title: LocalizedStringKey
    let footer: LocalizedStringKey?
    let style: AdaptiveSectionStyle
    let content: Content

    init(
        title: LocalizedStringKey,
        footer: LocalizedStringKey? = nil,
        style: AdaptiveSectionStyle = .form,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.footer = footer
        self.style = style
        self.content = content()
    }

    var body: some View {
        #if os(iOS)
        if style == .form {
            Section {
                content
            } header: {
                Text(title)
            } footer: {
                if let footer {
                    Text(footer)
                }
            }
        } else {
            cardLayout
        }
        #else
        cardLayout
        #endif
    }

    private var cardLayout: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.tankoSecondary)
                .padding(.horizontal)

            content
                .padding()
                .backgroundStyle(.surface)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.05), radius: 8, y: 3)
                .padding(.horizontal)

            if let footer {
                Text(footer)
                    .font(.caption)
                    .foregroundStyle(.tankoSecondary)
                    .padding(.horizontal)
            }
        }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 32) {
            // Example Card style
            AdaptiveSectionContainer(
                title: "Card Style",
                footer: "Ideal for general content sections",
                style: .card
            ) {
                Text("This content is wrapped in a card-like container with padding and shadow, making it stand out from the background.")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Example Form style
            List {
                AdaptiveSectionContainer(
                    title: "Form Style",
                    footer: "Ideal for settings or input sections",
                    style: .form
                ) {
                    Text("This content is wrapped in a form section, which is more compact and integrates with the list style, making it suitable for forms or settings.")
                }
            }
            .listStyle(.insetGrouped)
            .frame(height: 200)
        }
        .padding(.vertical)
    }
    .background(.surface)
}
