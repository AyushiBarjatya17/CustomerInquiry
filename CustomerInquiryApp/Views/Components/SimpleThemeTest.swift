//
//  SimpleThemeTest.swift
//  CustomerInquiryApp
//
//  Created by: [Your Name]
//  Date: [Current Date]
//

import SwiftUI

struct SimpleThemeTest: View {
    @Environment(\.theme) var theme
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Theme Test")
                .font(.title)
                .foregroundColor(theme.primaryText)
            
            Text("Theme: \(theme.name)")
                .foregroundColor(theme.secondaryText)
            
            Text("Is Dark: \(theme.isDark ? "Yes" : "No")")
                .foregroundColor(theme.secondaryText)
            
            Rectangle()
                .fill(theme.primaryAccent)
                .frame(height: 50)
                .cornerRadius(10)
        }
        .padding()
        .background(theme.primaryBackground)
    }
}

#Preview {
    SimpleThemeTest()
        .environment(\.theme, DarkTheme())
}

