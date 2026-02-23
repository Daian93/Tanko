//
//  AppearanceSection.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/2/26.
//

import SwiftUI

struct AppearanceSection: View {
    @Binding var isDarkMode: Bool

    var body: some View {
        Toggle(isOn: $isDarkMode) {
            Label {
                Text("appearance.darkMode")
            } icon: {
                Image(systemName: isDarkMode ? "moon.stars.fill" : "moon.stars")
                    .foregroundStyle(.yellow)
                    .symbolEffect(.bounce, value: isDarkMode)
            }
        }
    }
}

#Preview {
    @Previewable @State var isDark = false
    
    List {
        AppearanceSection(isDarkMode: $isDark)
    }
}
