//
//  PreviewContainer.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/1/26.
//

import SwiftUI
import SwiftData

struct PreviewContainer: PreviewModifier {

    static func makeSharedContext() async throws -> ModelContainer {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(
            for: UserManga.self,
            configurations: configuration
        )

        UserManga.sampleCollection.forEach {
            container.mainContext.insert($0)
        }

        try container.mainContext.save()
        return container
    }

    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var sampleData: Self = .modifier(PreviewContainer())
}
