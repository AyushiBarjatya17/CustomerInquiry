//
//  UserProfileView.swift
//  CustomerInquiryApp
//
//  Created by: [Your Name]
//  Date: [Current Date]
//

import SwiftUI

struct UserProfileView: View {
    @Environment(\.theme) var theme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    let userName: String
    let userAvatar: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Language Flag Icon
            Button(action: {
                // Language selection action
            }) {
                Image(systemName: "flag.fill")
                    .font(.system(size: horizontalSizeClass == .regular ? 18 : 16))
                    .foregroundColor(theme.secondaryText)
            }
            .buttonStyle(PlainButtonStyle())
            
            // User Profile
            Button(action: {
                // User profile action
            }) {
                HStack(spacing: 12) {
                    // Avatar
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [theme.primaryAccent, theme.secondaryAccent],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: horizontalSizeClass == .regular ? 40 : 36, height: horizontalSizeClass == .regular ? 40 : 36)
                        
                        Text(String(userName.prefix(1)))
                            .font(.system(size: horizontalSizeClass == .regular ? 18 : 16, weight: .semibold))
                            .foregroundColor(theme.accentText)
                    }
                    
                    // User Name
                    Text(userName)
                        .font(.system(size: horizontalSizeClass == .regular ? 16 : 14, weight: .medium))
                        .foregroundColor(theme.primaryText)
                    
                    // Dropdown Arrow
                    Image(systemName: "chevron.down")
                        .font(.system(size: horizontalSizeClass == .regular ? 14 : 12, weight: .medium))
                        .foregroundColor(theme.secondaryText)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

#Preview {
    Group {
        UserProfileView(userName: "Jonathan Smith", userAvatar: "person.circle")
            .environment(\.theme, DarkTheme())
            .preferredColorScheme(.dark)
            .padding()
            .background(DarkTheme().primaryBackground)
        
        UserProfileView(userName: "Jonathan Smith", userAvatar: "person.circle")
            .environment(\.theme, LightTheme())
            .preferredColorScheme(.light)
            .padding()
            .background(LightTheme().primaryBackground)
    }
}

