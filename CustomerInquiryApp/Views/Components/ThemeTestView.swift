//
//  ThemeTestView.swift
//  CustomerInquiryApp
//
//  Created by: [Your Name]
//  Date: [Current Date]
//

import SwiftUI

struct ThemeTestView: View {
    @Environment(\.theme) var theme
    @ObservedObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Theme Test")
                .font(.largeTitle)
                .foregroundColor(theme.primaryText)
            
            Text("Current Theme: \(theme.name)")
                .font(.title2)
                .foregroundColor(theme.secondaryText)
            
            Text("Is Dark: \(theme.isDark ? "Yes" : "No")")
                .font(.body)
                .foregroundColor(theme.secondaryText)
            
            Button("Toggle Theme") {
                themeManager.toggleTheme()
            }
            .padding()
            .background(theme.primaryAccent)
            .foregroundColor(theme.accentText)
            .cornerRadius(10)
            
            // Color samples
            VStack(spacing: 10) {
                Text("Color Samples")
                    .font(.headline)
                    .foregroundColor(theme.primaryText)
                
                HStack(spacing: 20) {
                    Circle()
                        .fill(theme.primaryAccent)
                        .frame(width: 50, height: 50)
                    
                    Circle()
                        .fill(theme.secondaryAccent)
                        .frame(width: 50, height: 50)
                    
                    Circle()
                        .fill(theme.successColor)
                        .frame(width: 50, height: 50)
                }
            }
        }
        .padding()
        .background(theme.primaryBackground)
    }
}

#Preview {
    ThemeTestView(themeManager: ThemeManager.shared)
        .environment(\.theme, DarkTheme())
        .preferredColorScheme(.dark)
}

