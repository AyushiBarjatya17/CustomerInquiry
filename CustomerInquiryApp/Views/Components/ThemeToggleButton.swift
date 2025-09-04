//
//  ThemeToggleButton.swift
//  CustomerInquiryApp
//
//  Created by: [Your Name]
//  Date: [Current Date]
//

import SwiftUI

struct ThemeToggleButton: View {
    @Environment(\.theme) var theme
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        Button(action: {
            print("ThemeToggleButton tapped - Current theme: \(themeManager.currentTheme.name)")
            withAnimation(.easeInOut(duration: 0.3)) {
                themeManager.toggleTheme()
            }
            print("ThemeToggleButton tapped - New theme: \(themeManager.currentTheme.name)")
        }) {
            HStack(spacing: horizontalSizeClass == .regular ? 8 : 6) {
                Image(systemName: theme.isDark ? "sun.max.fill" : "moon.fill")
                    .font(.system(size: horizontalSizeClass == .regular ? 16 : 14, weight: .medium))
                    .foregroundColor(theme.isDark ? .yellow : .purple)
                
                if horizontalSizeClass == .regular {
                    Text(theme.isDark ? "Light" : "Dark")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(theme.primaryText)
                }
            }
            .padding(.horizontal, horizontalSizeClass == .regular ? 12 : 10)
            .padding(.vertical, horizontalSizeClass == .regular ? 8 : 6)
            .background(
                RoundedRectangle(cornerRadius: horizontalSizeClass == .regular ? 20 : 18)
                    .fill(theme.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: horizontalSizeClass == .regular ? 20 : 18)
                            .stroke(theme.borderColor, lineWidth: 1)
                    )
            )
            .shadow(color: theme.shadowColor, radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    Group {
        ThemeToggleButton()
            .environment(\.theme, DarkTheme())
            .environmentObject(ThemeManager.shared)
            .preferredColorScheme(.dark)
            .padding()
            .background(DarkTheme().primaryBackground)
        
        ThemeToggleButton()
            .environment(\.theme, LightTheme())
            .environmentObject(ThemeManager.shared)
            .preferredColorScheme(.light)
            .padding()
            .background(LightTheme().primaryBackground)
    }
}
