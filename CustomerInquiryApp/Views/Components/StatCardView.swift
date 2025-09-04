import SwiftUI

struct StatCardView: View {
    @Environment(\.theme) var theme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    let stat: DashboardStat
    
    var body: some View {
        HStack(spacing: 16) {
            // Left: Circular Icon
            ZStack {
                Circle()
                    .fill(theme.cardBackground)
                    .frame(width: horizontalSizeClass == .regular ? 56 : 48, height: horizontalSizeClass == .regular ? 56 : 48)
                
                Image(systemName: stat.icon)
                    .font(.system(size: horizontalSizeClass == .regular ? 24 : 20, weight: .medium))
                    .foregroundColor(theme.primaryAccent)
            }
            
            // Center: Separator Line
            Rectangle()
                .fill(theme.borderColor)
                .frame(width: 1, height: horizontalSizeClass == .regular ? 50 : 40)
            
            // Right: Statistics
            VStack(alignment: .leading, spacing: 4) {
                // Value
                Text(stat.value)
                    .font(.system(size: horizontalSizeClass == .regular ? 28 : 24, weight: .bold, design: .rounded))
                    .foregroundColor(theme.primaryText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                // Label
                Text(stat.label)
                    .font(.system(size: horizontalSizeClass == .regular ? 12 : 10, weight: .medium))
                    .foregroundColor(theme.secondaryText)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(horizontalSizeClass == .regular ? 20 : 16)
        .frame(maxWidth: .infinity)
        .frame(height: horizontalSizeClass == .regular ? 120 : 100)
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


