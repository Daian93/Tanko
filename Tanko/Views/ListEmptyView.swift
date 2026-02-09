//
//  ListEmptyView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 24/1/26.
//

import SwiftUI

struct ListEmptyView: View {
    var body: some View {
        ContentUnavailableView(
            "empty.title",
            systemImage: "book.closed.fill",
            description: Text(
                "empty.description"
            )
        )
    }
}

#Preview {
    ListEmptyView()
}
