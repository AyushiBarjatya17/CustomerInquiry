//
//  DateHelper.swift
//  CustomerInquiryApp
//
//  Created by: [Your Name]
//  Date: [Current Date]
//

import Foundation

/// Helper functions for date manipulation and formatting
struct DateHelper {
    
    /// Formats a date to a user-friendly string
    /// - Parameter date: The date to format
    /// - Returns: Formatted date string
    static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    /// Gets a relative time string (e.g., "2 hours ago")
    /// - Parameter date: The date to get relative time for
    /// - Returns: Relative time string
    static func relativeTimeString(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    /// Checks if a date is today
    /// - Parameter date: The date to check
    /// - Returns: True if the date is today
    static func isToday(_ date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
    
    /// Gets the start of the day for a given date
    /// - Parameter date: The date to get start of day for
    /// - Returns: Start of day date
    static func startOfDay(for date: Date) -> Date {
        Calendar.current.startOfDay(for: date)
    }
}

