//
//  TorahLogoView.swift
//  CustomerInquiryApp
//
//  Created by: [Your Name]
//  Date: [Current Date]
//

import SwiftUI

struct TorahLogoView: View {
    @Environment(\.theme) var theme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        HStack(spacing: 12) {
            // Crown/Flame Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [theme.primaryAccent, theme.secondaryAccent],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: horizontalSizeClass == .regular ? 48 : 40, height: horizontalSizeClass == .regular ? 48 : 40)
                
                Image(systemName: "crown.fill")
                    .font(.system(size: horizontalSizeClass == .regular ? 24 : 20, weight: .medium))
                    .foregroundColor(theme.accentText)
            }
            
            // Text Logo
            VStack(alignment: .leading, spacing: 2) {
                Text("TORAH")
                    .font(.system(size: horizontalSizeClass == .regular ? 28 : 24, weight: .bold, design: .rounded))
                    .foregroundColor(theme.primaryText)
                
                Text("Artificial Intelligence")
                    .font(.system(size: horizontalSizeClass == .regular ? 14 : 12, weight: .medium))
                    .foregroundColor(theme.secondaryText)
            }
        }
    }
}

#Preview {
    Group {
        TorahLogoView()
            .environment(\.theme, DarkTheme())
            .preferredColorScheme(.dark)
            .padding()
            .background(DarkTheme().primaryBackground)
        
        TorahLogoView()
            .environment(\.theme, LightTheme())
            .preferredColorScheme(.light)
            .padding()
            .background(LightTheme().primaryBackground)
    }
}

