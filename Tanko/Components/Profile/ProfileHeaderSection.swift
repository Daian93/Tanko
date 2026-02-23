//
//  ProfileHeaderSection.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/2/26.
//

import SwiftUI

struct ProfileHeaderSection: View {
    @Binding var userName: String
    let emoji: String
    let onTapEmoji: () -> Void

    var body: some View {
        VStack(spacing: 15) {
            Text(emoji)
                .font(.system(size: 80))
                .padding()
                .background(Circle().fill(Color.blue.opacity(0.1)))
                .onTapGesture(perform: onTapEmoji)

            TextField("profile.name", text: $userName)
                .multilineTextAlignment(.center)
                .font(.headline)
        }
        .padding(.vertical)
    }
}

#Preview {
    ProfileHeaderSection(userName: .constant("Diana"), emoji: "🌸", onTapEmoji: {})
}
