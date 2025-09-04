//
//  RecentCustomerListView.swift
//  CustomerInquiryApp
//
//  Created by: [Your Name]
//  Date: [Current Date]
//

import SwiftUI

struct RecentCustomerListView: View {
    @Environment(\.theme) var theme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    let recentCustomers: [RecentChat]
    let onCustomerTapped: (RecentChat) -> Void
    let onSeeAllTapped: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                Image(systemName: "person.2.fill")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(theme.primaryAccent)
                
                Text("Recent Customers")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(theme.primaryText)
                
                Spacer()
                
                // See All Button
                Button(action: onSeeAllTapped) {
                    Text("See All")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(theme.primaryAccent)
                }
            }
            
            // Customer List
            VStack(spacing: 16) {
                ForEach(recentCustomers) { customer in
                    Button(action: { onCustomerTapped(customer) }) {
                        HStack(spacing: 16) {
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
                                    .frame(width: horizontalSizeClass == .regular ? 48 : 40, height: horizontalSizeClass == .regular ? 48 : 40)
                                
                                Text(customer.avatar)
                                    .font(.system(size: horizontalSizeClass == .regular ? 18 : 16, weight: .semibold))
                                    .foregroundColor(theme.accentText)
                            }
                            
                            // Customer Info
                            VStack(alignment: .leading, spacing: 4) {
                                Text(customer.name)
                                    .font(.system(size: horizontalSizeClass == .regular ? 16 : 14, weight: .semibold))
                                    .foregroundColor(theme.primaryText)
                                    .lineLimit(1)
                                
                                Text(customer.description)
                                    .font(.system(size: horizontalSizeClass == .regular ? 12 : 10, weight: .medium))
                                    .foregroundColor(theme.secondaryText)
                                    .lineLimit(1)
                            }
                            
                            Spacer()
                            
                            // Customer Icon
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: horizontalSizeClass == .regular ? 18 : 16, weight: .medium))
                                .foregroundColor(theme.primaryAccent)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(theme.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(theme.borderColor, lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(theme.borderColor, lineWidth: 1)
                )
        )
        .shadow(color: theme.shadowColor, radius: 4, x: 0, y: 2)
    }
}

#Preview {
    let recentCustomers = [
        RecentChat(avatar: "V", name: "Va'etchanan", description: "Chumash / Devarim", avatarColor: "purple"),
        RecentChat(avatar: "S", name: "Shabbat", description: "Talmud / Seder Moed", avatarColor: "blue"),
        RecentChat(avatar: "G", name: "GPT-4", description: "Generic chatbots", avatarColor: "green"),
        RecentChat(avatar: "B", name: "Bereshit", description: "Lech Lecha", avatarColor: "orange")
    ]
    
    return Group {
        RecentCustomerListView(recentCustomers: recentCustomers, onCustomerTapped: { _ in }, onSeeAllTapped: { })
            .environment(\.theme, DarkTheme())
            .preferredColorScheme(.dark)
            .padding()
            .background(DarkTheme().primaryBackground)
        
        RecentCustomerListView(recentCustomers: recentCustomers, onCustomerTapped: { _ in }, onSeeAllTapped: { })
            .environment(\.theme, LightTheme())
            .preferredColorScheme(.light)
            .padding()
            .background(LightTheme().primaryBackground)
    }
}
