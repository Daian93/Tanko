//
//  WidgetTheme.swift
//  TankoWidget
//
//  Created by Diana Rammal Sansón on 16/2/26.
//

import SwiftUI

enum WidgetTheme {
    
    // MARK: - Colors
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 0.85, green: 0.25, blue: 0.3).opacity(0.3),
            Color(red: 0.7, green: 0.2, blue: 0.25).opacity(0.3),
            Color(red: 0.55, green: 0.15, blue: 0.2).opacity(0.3)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static func progressColor(for progress: Double) -> Color {
        switch progress {
        case 0..<0.33:
            return .red.opacity(0.85)
        case 0.33..<0.66:
            return .orange.opacity(0.85)
        default:
            return .green.opacity(0.85)
        }
    }
    
    // MARK: - Spacing
    
    enum Spacing {
        static let cardPadding: CGFloat = 12
        static let cardSpacing: CGFloat = 16
        static let badgePadding: CGFloat = 10
    }
    
    // MARK: - Sizes
    
    enum Size {
        static let progressBarHeight: CGFloat = 5
        static let borderRadius: CGFloat = 16
        static let borderWidth: CGFloat = 1
    }
}
