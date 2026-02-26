//
//  ContactSection.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 23/2/26.
//

import SwiftUI

struct ContactSection: View {
    private let supportEmail = "support@tankoapp.com"
    // Will be replaced with the actual App Store ID when available
    private let appStoreID   = "123456789"

    var body: some View {
        Group {
            // Score the app on the App Store
            Button {
                openAppStore()
            } label: {
                Label {
                    Text("contact.rate")
                } icon: {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                }
            }

            // Send feedback via email
            Button {
                openMail()
            } label: {
                Label {
                    Text("contact.feedback")
                } icon: {
                    Image(systemName: "envelope.fill")
                        .foregroundStyle(.blue)
                }
            }
        }
        .background(.surface)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Actions

    private func openAppStore() {
        let urlString = "itms-apps://itunes.apple.com/app/id\(appStoreID)?action=write-review"
        guard let url = URL(string: urlString) else { return }
        #if os(iOS)
        UIApplication.shared.open(url)
        #elseif os(macOS)
        NSWorkspace.shared.open(url)
        #endif
    }

    private func openMail() {
        let subject = "Email subject"
        let urlString = "mailto:\(supportEmail)?subject=\(subject)"
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else { return }
        #if os(iOS)
        UIApplication.shared.open(url)
        #elseif os(macOS)
        NSWorkspace.shared.open(url)
        #endif
    }
}

#Preview {
    List {
        ContactSection()
    }
}
