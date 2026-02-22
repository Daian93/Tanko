//
//  SectionContainer.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 22/2/26.
//

import SwiftUI

struct SectionContainer<Content: View>: View {
    let title: LocalizedStringKey
    let footer: LocalizedStringKey?
    let content: Content

    init(
        title: LocalizedStringKey,
        footer: LocalizedStringKey? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.footer = footer
        self.content = content()
    }

    var body: some View {
        #if os(macOS)
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)

            content
                .padding()
                .backgroundStyle(.surface)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            if let footer {
                Text(footer)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        #else
        Section {
            content
        } header: {
            Text(title)
        } footer: {
            if let footer {
                Text(footer)
            }
        }
        #endif
    }
}

#Preview {
    SectionContainer(title: "Section Title", footer: "This is the footer") {
        Text("This is the content of the section.")
    }
}
