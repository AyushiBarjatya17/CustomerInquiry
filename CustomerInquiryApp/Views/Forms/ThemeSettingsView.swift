//
//  ThemeSettingsView.swift
//  CustomerInquiryApp
//
//  Created by: [Your Name]
//  Date: [Current Date]
//

import SwiftUI

struct ThemeSettingsView: View {
    @Environment(\.theme) var theme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @ObservedObject var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: "paintbrush.fill")
                        .font(.system(size: 48, weight: .medium))
                        .foregroundColor(theme.primaryAccent)
                    
                    Text("Choose Your Theme")
                        .font(.system(size: horizontalSizeClass == .regular ? 28 : 24, weight: .bold))
                        .foregroundColor(theme.primaryText)
                    
                    Text("Select the appearance that works best for you")
                        .font(.system(size: horizontalSizeClass == .regular ? 16 : 14, weight: .medium))
                        .foregroundColor(theme.secondaryText)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 32)
                
                // Theme Options
                VStack(spacing: 16) {
                    // Light Theme Option
                    ThemeOptionCard(
                        theme: LightTheme(),
                        isSelected: themeManager.currentTheme.name == "Light",
                        onTap: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                themeManager.setTheme("Light")
                            }
                        }
                    )
                    
                    // Dark Theme Option
                    ThemeOptionCard(
                        theme: DarkTheme(),
                        isSelected: themeManager.currentTheme.name == "Dark",
                        onTap: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                themeManager.setTheme("Dark")
                            }
                        }
                    )
                }
                .padding(.horizontal, horizontalSizeClass == .regular ? 32 : 24)
                
                Spacer()
                
                // Done Button
                Button(action: { dismiss() }) {
                    Text("Done")
                        .font(.system(size: horizontalSizeClass == .regular ? 18 : 16, weight: .semibold))
                        .foregroundColor(theme.accentText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, horizontalSizeClass == .regular ? 16 : 14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(theme.primaryAccent)
                        )
                }
                .padding(.horizontal, horizontalSizeClass == .regular ? 32 : 24)
                .padding(.bottom, 32)
            }
            .background(theme.primaryBackground)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Theme Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(theme.primaryAccent)
                }
            }
        }
    }
}

struct ThemeOptionCard: View {
    let theme: AppTheme
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Theme Preview
                VStack(spacing: 8) {
                    // Mock UI Elements
                    HStack(spacing: 8) {
                        Circle()
                            .fill(theme.primaryAccent)
                            .frame(width: 24, height: 24)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(theme.cardBackground)
                            .frame(width: 60, height: 8)
                    }
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(theme.cardBackground)
                        .frame(height: 40)
                }
                .padding(12)
                .background(theme.secondaryBackground)
                .cornerRadius(12)
                
                // Theme Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(theme.name)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(theme.primaryText)
                    
                    Text(theme.isDark ? "Dark appearance" : "Light appearance")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(theme.secondaryText)
                }
                
                Spacer()
                
                // Selection Indicator
                ZStack {
                    Circle()
                        .fill(theme.borderColor)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Circle()
                            .fill(theme.primaryAccent)
                            .frame(width: 16, height: 16)
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(theme.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? theme.primaryAccent : theme.borderColor, lineWidth: isSelected ? 2 : 1)
                    )
            )
            .shadow(color: theme.shadowColor, radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ThemeSettingsView(themeManager: ThemeManager.shared)
        .environment(\.theme, DarkTheme())
        .preferredColorScheme(.dark)
}

