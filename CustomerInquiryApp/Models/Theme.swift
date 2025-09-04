//
//  Theme.swift
//  CustomerInquiryApp
//
//  Created by: [Your Name]
//  Date: [Current Date]
//

import SwiftUI

// MARK: - Theme Protocol
protocol AppTheme: Equatable {
    var name: String { get }
    var isDark: Bool { get }
    
    // MARK: - Background Colors
    var primaryBackground: Color { get }
    var secondaryBackground: Color { get }
    var cardBackground: Color { get }
    var modalBackground: Color { get }
    
    // MARK: - Text Colors
    var primaryText: Color { get }
    var secondaryText: Color { get }
    var accentText: Color { get }
    var placeholderText: Color { get }
    
    // MARK: - Accent Colors
    var primaryAccent: Color { get }
    var secondaryAccent: Color { get }
    var successColor: Color { get }
    var warningColor: Color { get }
    var errorColor: Color { get }
    
    // MARK: - UI Element Colors
    var borderColor: Color { get }
    var shadowColor: Color { get }
    var dividerColor: Color { get }
    
    // MARK: - Event Card Colors
    var yomKippurBackground: Color { get }
    var hanukkahBackground: Color { get }
    var passoverBackground: Color { get }
    var flowerColor: Color { get }
    
    // MARK: - Chart Colors
    var chartLinePrimary: Color { get }
    var chartLineSecondary: Color { get }
    var chartGrid: Color { get }
}

// MARK: - Light Theme
struct LightTheme: AppTheme, Equatable {
    let name = "Light"
    let isDark = false
    
    // Background Colors
    var primaryBackground: Color { Color(red: 0.98, green: 0.98, blue: 0.98) } // #FAFAFA
    var secondaryBackground: Color { Color.white }
    var cardBackground: Color { Color.white }
    var modalBackground: Color { Color.white }
    
    // Text Colors
    var primaryText: Color { Color(red: 0.1, green: 0.1, blue: 0.1) } // #1A1A1A
    var secondaryText: Color { Color(red: 0.4, green: 0.4, blue: 0.4) } // #666666
    var accentText: Color { Color.white }
    var placeholderText: Color { Color(red: 0.6, green: 0.6, blue: 0.6) } // #999999
    
    // Accent Colors
    var primaryAccent: Color { Color(red: 0.4, green: 0.2, blue: 0.8) } // #6633CC
    var secondaryAccent: Color { Color(red: 0.6, green: 0.4, blue: 0.9) } // #9966E6
    var successColor: Color { Color(red: 0.2, green: 0.7, blue: 0.3) } // #33B34D
    var warningColor: Color { Color(red: 0.9, green: 0.6, blue: 0.2) } // #E69933
    var errorColor: Color { Color(red: 0.8, green: 0.2, blue: 0.2) } // #CC3333
    
    // UI Element Colors
    var borderColor: Color { Color(red: 0.9, green: 0.9, blue: 0.9) } // #E6E6E6
    var shadowColor: Color { Color.black.opacity(0.1) }
    var dividerColor: Color { Color(red: 0.9, green: 0.9, blue: 0.9) } // #E6E6E6
    
    // Event Card Colors
    var yomKippurBackground: Color { Color(red: 0.4, green: 0.2, blue: 0.8) } // #6633CC
    var hanukkahBackground: Color { Color(red: 0.2, green: 0.4, blue: 0.8) } // #3366CC
    var passoverBackground: Color { Color(red: 0.8, green: 0.5, blue: 0.2) } // #CC8033
    var flowerColor: Color { Color(red: 0.1, green: 0.1, blue: 0.1) } // #CC8033
    
    // Chart Colors
    var chartLinePrimary: Color { Color(red: 0.6, green: 0.4, blue: 0.9) } // #9966E6
    var chartLineSecondary: Color { Color(red: 0.4, green: 0.2, blue: 0.8) } // #6633CC
    var chartGrid: Color { Color(red: 0.9, green: 0.9, blue: 0.9) } // #E6E6E6
    
    // MARK: - Equatable
    static func == (lhs: LightTheme, rhs: LightTheme) -> Bool {
        return lhs.name == rhs.name && lhs.isDark == rhs.isDark
    }
}

// MARK: - Dark Theme
struct DarkTheme: AppTheme, Equatable {
    let name = "Dark"
    let isDark = true
    
    // Background Colors
    var primaryBackground: Color { Color(red: 0.08, green: 0.08, blue: 0.12) } // #141420
    var secondaryBackground: Color { Color(red: 0.12, green: 0.12, blue: 0.18) } // #1E1E2E
    var cardBackground: Color { Color(red: 0.16, green: 0.16, blue: 0.24) } // #282836
    var modalBackground: Color { Color(red: 0.2, green: 0.2, blue: 0.3) } // #333348
    
    // Text Colors
    var primaryText: Color { Color.white }
    var secondaryText: Color { Color(red: 0.8, green: 0.8, blue: 0.9) } // #CCCCE6
    var accentText: Color { Color.white }
    var placeholderText: Color { Color(red: 0.6, green: 0.6, blue: 0.7) } // #9999B3
    
    // Accent Colors
    var primaryAccent: Color { Color(red: 0.6, green: 0.4, blue: 0.9) } // #9966E6
    var secondaryAccent: Color { Color(red: 0.8, green: 0.6, blue: 1.0) } // #CC99FF
    var successColor: Color { Color(red: 0.4, green: 0.8, blue: 0.5) } // #66CC80
    var warningColor: Color { Color(red: 1.0, green: 0.8, blue: 0.4) } // #FFCC66
    var errorColor: Color { Color(red: 1.0, green: 0.4, blue: 0.4) } // #FF6666
    
    // UI Element Colors
    var borderColor: Color { Color(red: 0.3, green: 0.3, blue: 0.4) } // #4D4D66
    var shadowColor: Color { Color.black.opacity(0.3) }
    var dividerColor: Color { Color(red: 0.3, green: 0.3, blue: 0.4) } // #4D4D66
    
    // Event Card Colors
    var yomKippurBackground: Color { Color(red: 0.5, green: 0.3, blue: 0.9) } // #804DE6
    var hanukkahBackground: Color { Color(red: 0.3, green: 0.5, blue: 0.9) } // #4D80E6
    var passoverBackground: Color { Color(red: 0.9, green: 0.6, blue: 0.3) } // #E6994D
    var flowerColor: Color { Color.white }
    // Chart Colors
    var chartLinePrimary: Color { Color(red: 0.8, green: 0.6, blue: 1.0) } // #CC99FF
    var chartLineSecondary: Color { Color(red: 0.6, green: 0.4, blue: 0.9) } // #9966E6
    var chartGrid: Color { Color(red: 0.3, green: 0.3, blue: 0.4) } // #4D4D66
    
    // MARK: - Equatable
    static func == (lhs: DarkTheme, rhs: DarkTheme) -> Bool {
        return lhs.name == rhs.name && lhs.isDark == rhs.isDark
    }
}

// MARK: - Theme Manager
class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var currentTheme: AppTheme {
        didSet {
            UserDefaults.standard.set(currentTheme.name, forKey: "selectedTheme")
        }
    }
    
    private init() {
        let savedTheme = UserDefaults.standard.string(forKey: "selectedTheme") ?? "Dark"
        self.currentTheme = savedTheme == "Light" ? LightTheme() : DarkTheme()
    }
    
    func toggleTheme() {
        print("ThemeManager.toggleTheme() called - Current: \(currentTheme.name)")
        currentTheme = currentTheme is LightTheme ? DarkTheme() : LightTheme()
        print("ThemeManager.toggleTheme() completed - New: \(currentTheme.name)")
    }
    
    func setTheme(_ themeName: String) {
        currentTheme = themeName == "Light" ? LightTheme() : DarkTheme()
    }
}

// MARK: - Theme Environment Key
struct ThemeKey: EnvironmentKey {
    static let defaultValue: AppTheme = DarkTheme()
}

extension EnvironmentValues {
    var theme: AppTheme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}
