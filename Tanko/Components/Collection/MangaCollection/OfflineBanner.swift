//
//  OfflineBanner.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/2/26.
//

import SwiftUI

struct OfflineBanner: View {
    let isConnected: Bool
    let pendingCount: Int

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: isConnected ? "arrow.triangle.2.circlepath" : "wifi.slash")
                .font(.title3)
                .foregroundStyle(isConnected ? .blue : .orange)

            VStack(alignment: .leading, spacing: 4) {
                Text(isConnected ? "offline.sync" : "offline.no.connection")
                    .font(.subheadline.bold())

                Text("\(pendingCount) offline.changes")
                    .font(.caption)
                    .foregroundStyle(.tankoSecondary)
            }

            Spacer()

            Image(systemName: isConnected ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                .foregroundStyle(isConnected ? .blue : .orange)
        }
        .padding()
        .background(isConnected ? Color.blue.opacity(0.10) : Color.orange.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

#Preview {
    VStack(spacing: 16) {
        OfflineBanner(isConnected: false, pendingCount: 3)
        OfflineBanner(isConnected: true, pendingCount: 2)
    }
    .padding()
}
