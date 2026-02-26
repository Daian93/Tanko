//
//  LogoutSection.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/2/26.
//

import SwiftUI

struct LogoutSection: View {
    let isGuest: Bool
    let action: () -> Void

    var body: some View {
        Group {
            if isGuest {
                Button(role: .destructive, action: action) {
                    Label("logout.guest", systemImage: "arrow.left.circle")
                }
            } else {
                Button(role: .destructive, action: action) {
                    Label("logout.user", systemImage: "rectangle.portrait.and.arrow.right")
                }
            }
        }
    }
}

#Preview {
    LogoutSection(isGuest: false, action: {})
}
