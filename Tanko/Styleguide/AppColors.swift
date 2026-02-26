//
//  AppColors.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 24/1/26.
//

import SwiftUI

// Define custom colors for the app using an extension on ShapeStyle, which allows us to use these colors in various SwiftUI views.
extension ShapeStyle where Self == Color {
    static var tankoPrimary: Color { Color("TankoMainPrimary") }
    static var tankoSecondary: Color { Color("TankoMainSecondary") }
    static var tankoBackground: Color { Color("TankoMainBackground") }
    static var surface: Color { Color("TankoCardSurface") }
    static var textPrimary: Color { Color("TankoTextPrimary") }
    static var textSecondary: Color { Color("TankoTextSecondary") }
}
