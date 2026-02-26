//
//  LoadingBranding.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 25/2/26.
//

import SwiftUI

struct LoadingBranding: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("app.name")
                .font(.headline)
                .fontWeight(.black)
                .foregroundStyle(.white)

            Text("app.subtext")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.7))
        }
        .padding(.bottom, 40)
    }
}

#Preview {
    ZStack {
        Color.tankoPrimary.opacity(0.65)
            .ignoresSafeArea()
        LoadingBranding()
    }
}
