//
//  Color+Theme.swift
//  CustomerInquiryApp
//
//  Created by: [Your Name]
//  Date: [Current Date]
//

import SwiftUI

extension Color {
    // MARK: - Theme-Aware Colors
    static var themePrimaryBackground: Color {
        Color("PrimaryBackground", bundle: nil)
    }
    
    static var themeSecondaryBackground: Color {
        Color("SecondaryBackground", bundle: nil)
    }
    
    static var themeCardBackground: Color {
        Color("CardBackground", bundle: nil)
    }
    
    static var themePrimaryText: Color {
        Color("PrimaryText", bundle: nil)
    }
    
    static var themeSecondaryText: Color {
        Color("SecondaryText", bundle: nil)
    }
    
    static var themePrimaryAccent: Color {
        Color("PrimaryAccent", bundle: nil)
    }
    
    static var themeSecondaryAccent: Color {
        Color("SecondaryAccent", bundle: nil)
    }
    
    static var themeBorder: Color {
        Color("Border", bundle: nil)
    }
    
    static var themeShadow: Color {
        Color("Shadow", bundle: nil)
    }
}

// MARK: - Theme Color Modifiers
extension View {
    func themedBackground(_ color: KeyPath<AppTheme, Color>) -> some View {
        self.background(Environment(\.theme).wrappedValue[keyPath: color])
    }
    
    func themedForeground(_ color: KeyPath<AppTheme, Color>) -> some View {
        self.foregroundColor(Environment(\.theme).wrappedValue[keyPath: color])
    }
    
    func themedBorder(_ color: KeyPath<AppTheme, Color>, width: CGFloat = 1) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: 0)
                .stroke(Environment(\.theme).wrappedValue[keyPath: color], lineWidth: width)
        )
    }
    
    func themedShadow(_ color: KeyPath<AppTheme, Color>, radius: CGFloat = 4, x: CGFloat = 0, y: CGFloat = 2) -> some View {
        self.shadow(color: Environment(\.theme).wrappedValue[keyPath: color], radius: radius, x: x, y: y)
    }
}

