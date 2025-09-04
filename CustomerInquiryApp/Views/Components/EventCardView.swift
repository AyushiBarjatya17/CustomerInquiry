//
//  EventCardView.swift
//  CustomerInquiryApp
//
//  Created by: [Your Name]
//  Date: [Current Date]
//

import SwiftUI

struct EventCardView: View {
    @Environment(\.theme) var theme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    let event: DashboardEvent
    let onChatTapped: () -> Void
    
    private var backgroundColor: Color {
        switch event.title {
        case "Yom Kippur":
            return theme.yomKippurBackground
        case "Hanukkah":
            return theme.hanukkahBackground
        case "Passover (Pesach)":
            return theme.passoverBackground
        default:
            return theme.primaryAccent
        }
    }
    
    private var buttonColor: Color {
        backgroundColor.opacity(0.8)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Event Title
            Text(event.title)
                .font(.system(size: horizontalSizeClass == .regular ? 20 : 18, weight: .bold))
                .foregroundColor(theme.accentText)
                .lineLimit(2)
            
            // Event Dates
            Text(event.dates)
                .font(.system(size: horizontalSizeClass == .regular ? 14 : 12, weight: .medium))
                .foregroundColor(theme.accentText.opacity(0.9))
                .lineLimit(3)
            
            Spacer()
            
            // Chat Now Button
            Button(action: onChatTapped) {
                HStack {
                    Image(systemName: "message.fill")
                        .font(.system(size: horizontalSizeClass == .regular ? 14 : 12, weight: .medium))
                    
                    Text("Chat Now")
                        .font(.system(size: horizontalSizeClass == .regular ? 14 : 12, weight: .semibold))
                }
                .foregroundColor(theme.accentText)
                .padding(.horizontal, horizontalSizeClass == .regular ? 20 : 16)
                .padding(.vertical, horizontalSizeClass == .regular ? 12 : 10)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(buttonColor)
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(horizontalSizeClass == .regular ? 24 : 20)
        .frame(height: horizontalSizeClass == .regular ? 200 : 180)
        .background(
            ZStack {
                
                FloralBackgroundView(accent: backgroundColor,accent_flower:theme.flowerColor)
                              .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            
                // Subtle Pattern Overlay
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [
                                backgroundColor.opacity(0.1),
                                backgroundColor.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        )
        .shadow(color: theme.shadowColor, radius: 8, x: 0, y: 4)
    }
}

#Preview {
    let event = DashboardEvent(
        title: "Yom Kippur",
        dates: "Sunset of Sun, September 24 - Nightfall of Mon, September 25",
        backgroundColor: "purple",
        patternColor: "purpleLight"
    )
    
    return Group {
        EventCardView(event: event) {}
            .environment(\.theme, DarkTheme())
            .preferredColorScheme(.dark)
            .padding()
            .background(DarkTheme().primaryBackground)
        
        EventCardView(event: event) {}
            .environment(\.theme, LightTheme())
            .preferredColorScheme(.light)
            .padding()
            .background(LightTheme().primaryBackground)
    }
}


