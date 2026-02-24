//
//  AppVersionSection.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/2/26.
//

import SwiftUI

struct AppVersionSection: View {

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    var body: some View {
        HStack {
            Label {
                Text("version.title")
            } icon: {
                Image(systemName: "info.circle.fill")
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text("tanko.version \(appVersion) (\(buildNumber))")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    List {
        AppVersionSection()
    }
}
