//
//  ThemeDemoView.swift
//  CustomerInquiryApp
//
//  Created by: [Your Name]
//  Date: [Current Date]
//

import SwiftUI

struct ThemeDemoView: View {
    @Environment(\.theme) var theme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @ObservedObject var themeManager: ThemeManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: "paintpalette.fill")
                        .font(.system(size: 48, weight: .medium))
                        .foregroundColor(theme.primaryAccent)
                    
                    Text("Theme Preview")
                        .font(.system(size: horizontalSizeClass == .regular ? 32 : 28, weight: .bold))
                        .foregroundColor(theme.primaryText)
                    
                    Text("See how your app looks with different themes")
                        .font(.system(size: horizontalSizeClass == .regular ? 16 : 14, weight: .medium))
                        .foregroundColor(theme.secondaryText)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 32)
                
                // Current Theme Info
                currentThemeSection
                
                // Component Showcase
                componentShowcaseSection
                
                // Color Palette
                colorPaletteSection
                
                // Theme Switch Button
                themeSwitchSection
            }
            .padding(.horizontal, horizontalSizeClass == .regular ? 32 : 24)
            .padding(.bottom, 32)
        }
        .background(theme.primaryBackground)
        .navigationTitle("Theme Demo")
        .navigationBarTitleDisplayMode(.large)
    }
    
    // MARK: - Current Theme Section
    private var currentThemeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Current Theme")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(theme.primaryText)
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(theme.name)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(theme.primaryText)
                    
                    Text(theme.isDark ? "Dark appearance with deep colors" : "Light appearance with bright colors")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(theme.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: theme.isDark ? "moon.stars.fill" : "sun.max.fill")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(theme.primaryAccent)
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
    
    // MARK: - Component Showcase Section
    private var componentShowcaseSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Component Showcase")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(theme.primaryText)
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                // Sample Event Card
                EventCardView(
                    event: DashboardEvent(
                        title: "Sample Event",
                        dates: "Today - Tomorrow",
                        backgroundColor: "purple",
                        patternColor: "purpleLight"
                    )
                ) {}
                
                // Sample Stat Card
                StatCardView(
                    stat: DashboardStat(
                        icon: "star.fill",
                        value: "42",
                        label: "sample stat"
                    )
                )
            }
        }
    }
    
    // MARK: - Color Palette Section
    private var colorPaletteSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Color Palette")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(theme.primaryText)
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
                ColorSwatch(name: "Primary", color: theme.primaryAccent)
                ColorSwatch(name: "Secondary", color: theme.secondaryAccent)
                ColorSwatch(name: "Success", color: theme.successColor)
                ColorSwatch(name: "Warning", color: theme.warningColor)
                ColorSwatch(name: "Error", color: theme.errorColor)
                ColorSwatch(name: "Border", color: theme.borderColor)
            }
        }
    }
    
    // MARK: - Theme Switch Section
    private var themeSwitchSection: some View {
        VStack(spacing: 16) {
            Text("Try Different Themes")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(theme.primaryText)
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    themeManager.toggleTheme()
                }
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.system(size: 18, weight: .medium))
                    
                    Text("Switch to \(theme.isDark ? "Light" : "Dark") Theme")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(theme.accentText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(theme.primaryAccent)
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: {
                // Show theme settings
            }) {
                Text("Customize Theme")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(theme.primaryAccent)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(theme.cardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(theme.primaryAccent, lineWidth: 1)
                            )
                    )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct ColorSwatch: View {
    let name: String
    let color: Color
    @Environment(\.theme) var theme
    
    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(theme.borderColor, lineWidth: 1)
                )
            
            Text(name)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(theme.secondaryText)
        }
    }
}

#Preview {
    NavigationView {
        ThemeDemoView(themeManager: ThemeManager.shared)
            .environment(\.theme, DarkTheme())
            .preferredColorScheme(.dark)
    }
}

