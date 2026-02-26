//
//  RootLoading.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 25/2/26.
//

import SwiftUI

struct RootLoading: View {
    let isAuthenticated: Bool

    var body: some View {
        LoadingView(message: isAuthenticated
                    ? "loading.text.user"
                    : "loading.text.guest")
        .transition(.opacity)
    }
}

#Preview {
    RootLoading(isAuthenticated: true)
}
