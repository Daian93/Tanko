//
//  Extensions.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 20/1/26.
//

import Foundation
import SwiftUI

extension String {
    var cleanedURL: String {
        self.replacingOccurrences(of: "\\", with: "")
            .replacingOccurrences(of: "\"", with: "")
            .trimmingCharacters(in: .init(charactersIn: "\""))
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var asURL: URL? {
        URL(string: cleanedURL)
    }

    func toDate() -> Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: self)
    }
}

// MARK: - macOS Compatibility
enum CompatibleTitleDisplayMode {
    case inline
    case large
    case automatic
}

enum CompatibleKeyboardType {
    case `default`
    case emailAddress
    case numberPad
    case decimalPad
}

enum CompatibleTextContentType {
    case emailAddress
    case password
    case username
    case newPassword
    case never
}

enum CompatibleToolbarItemPlacement {
    case topBarTrailing
    case topBarLeading
    case confirmationAction
    case cancellationAction

    #if os(iOS)
        var placement: ToolbarItemPlacement {
            switch self {
            case .topBarTrailing: return .topBarTrailing
            case .topBarLeading: return .topBarLeading
            case .confirmationAction: return .confirmationAction
            case .cancellationAction: return .cancellationAction
            }
        }
    #elseif os(macOS)
        var placement: ToolbarItemPlacement {
            switch self {
            case .topBarTrailing, .confirmationAction: return .automatic
            case .topBarLeading, .cancellationAction: return .automatic
            }
        }
    #endif
}

extension View {
    func keyboardTypeCompatible(_ type: CompatibleKeyboardType) -> some View {
        #if os(iOS)
            let uiKitType: UIKeyboardType = {
                switch type {
                case .default: return .default
                case .emailAddress: return .emailAddress
                case .numberPad: return .numberPad
                case .decimalPad: return .decimalPad
                }
            }()
            return AnyView(self.keyboardType(uiKitType))
        #else
            return AnyView(self)
        #endif
    }

    func textContentTypeCompatible(_ type: CompatibleTextContentType)
        -> some View
    {
        #if os(iOS)
            let uiKitType: UITextContentType? = {
                switch type {
                case .emailAddress: return .emailAddress
                case .password: return .password
                case .username: return .username
                case .newPassword: return .newPassword
                case .never: return nil
                }
            }()
            return AnyView(self.textContentType(uiKitType))
        #else
            return AnyView(self)
        #endif
    }

    func textInputAutocapitalizationCompatible() -> some View {
        #if os(iOS)
            return AnyView(self.textInputAutocapitalization(.never))
        #else
            return AnyView(self)
        #endif
    }

    func navigationBarTitleDisplayModeCompatible(
        _ mode: CompatibleTitleDisplayMode
    ) -> some View {
        #if os(iOS)
            let iosMode: NavigationBarItem.TitleDisplayMode = {
                switch mode {
                case .inline: return .inline
                case .large: return .large
                case .automatic: return .automatic
                }
            }()
            return AnyView(self.navigationBarTitleDisplayMode(iosMode))
        #else
            return AnyView(self)
        #endif
    }

    func navigationTransitionCompatible<ID: Hashable>(
        _ transition: Any,
        sourceID: ID,
        namespace: Namespace.ID
    ) -> some View {
        #if os(iOS)
            if let navTransition = transition as? NavigationTransition {
                return AnyView(self.navigationTransition(navTransition))
            }
            return AnyView(self)
        #else
            return AnyView(self)
        #endif
    }
}
