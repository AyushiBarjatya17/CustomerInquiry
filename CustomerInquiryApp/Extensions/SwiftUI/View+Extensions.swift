//
//  View+Extensions.swift
//  CustomerInquiryApp
//
//  Created by: [Your Name]
//  Date: [Current Date]
//

import SwiftUI

extension View {
    
    /// Applies a custom corner radius to specific corners
    /// - Parameters:
    ///   - radius: The corner radius value
    ///   - corners: The corners to apply the radius to
    /// - Returns: Modified view with custom corner radius
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    /// Adds a shadow with custom parameters
    /// - Parameters:
    ///   - color: Shadow color
    ///   - radius: Shadow radius
    ///   - x: Horizontal offset
    ///   - y: Vertical offset
    /// - Returns: Modified view with shadow
    func customShadow(color: Color = .black, radius: CGFloat = 10, x: CGFloat = 0, y: CGFloat = 5) -> some View {
        self.shadow(color: color.opacity(0.1), radius: radius, x: x, y: y)
    }
    
    /// Hides the view with animation
    /// - Parameter isHidden: Whether the view should be hidden
    /// - Returns: Modified view with hide animation
    func hide(_ isHidden: Bool) -> some View {
        self.opacity(isHidden ? 0 : 1)
            .animation(.easeInOut(duration: 0.3), value: isHidden)
    }
}

/// Custom shape for rounded corners
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

