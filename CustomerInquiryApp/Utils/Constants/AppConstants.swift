//
//  AppConstants.swift
//  CustomerInquiryApp
//
//  Created by: [Your Name]
//  Date: [Current Date]
//

import Foundation

/// App-wide constants and configuration values
struct AppConstants {
    
    // MARK: - API Configuration
    struct API {
        static let baseURL = "https://api.customerinquiry.com"
        static let timeoutInterval: TimeInterval = 30.0
        static let maxRetryAttempts = 3
    }
    
    // MARK: - UI Configuration
    struct UI {
        static let cornerRadius: CGFloat = 12.0
        static let animationDuration: Double = 0.3
        static let maxMessageLength = 500
    }
    
    // MARK: - Validation
    struct Validation {
        static let minPasswordLength = 8
        static let maxUsernameLength = 50
        static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    }
    
    // MARK: - Localization
    struct Localization {
        static let defaultLanguage = "en"
        static let supportedLanguages = ["en", "es", "fr"]
    }
}

