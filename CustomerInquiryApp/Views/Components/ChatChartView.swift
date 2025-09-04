//
//  ChatChartView.swift
//  CustomerInquiryApp
//
//  Created by: [Your Name]
//  Date: [Current Date]
//

import SwiftUI

struct ChatChartView: View {
    @Environment(\.theme) var theme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    let chatData: [ChatData]
    
    private var maxValue: Int {
        let maxPrevious = chatData.map { $0.previousWeekMinutes }.max() ?? 0
        let maxThis = chatData.map { $0.thisWeekMinutes }.max() ?? 0
        return max(maxPrevious, maxThis)
    }
    
    private var yAxisValues: [Int] {
        let step = max(1, maxValue / 4)
        return Array(stride(from: 0, through: maxValue + step, by: step))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(theme.primaryAccent)
                
                Text("Chatting Statistics")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(theme.primaryText)
                
                Spacer()
            }
            
            // Legend
            HStack(spacing: 20) {
                HStack(spacing: 8) {
                    Circle()
                        .fill(theme.chartLineSecondary)
                        .frame(width: 8, height: 8)
                    
                    Text("Previous week")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(theme.secondaryText)
                }
                
                HStack(spacing: 8) {
                    Circle()
                        .fill(theme.chartLinePrimary)
                        .frame(width: 8, height: 8)
                    
                    Text("This week")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(theme.secondaryText)
                }
            }
            
            // Chart
            ZStack {
                // Grid Lines
                VStack(spacing: 0) {
                    ForEach(yAxisValues, id: \.self) { value in
                        HStack {
                            Text("\(value)")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(theme.secondaryText)
                                .frame(width: 30, alignment: .trailing)
                            
                            Rectangle()
                                .fill(theme.chartGrid)
                                .frame(height: 1)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if value != yAxisValues.last {
                            Spacer()
                        }
                    }
                }
                
                // Chart Lines
                HStack(spacing: 0) {
                    ForEach(Array(chatData.enumerated()), id: \.element.id) { index, data in
                        VStack {
                            Spacer()
                            
                            // Previous Week Line
                            if index > 0 {
                                Path { path in
                                    let previousData = chatData[index - 1]
                                    let x1 = CGFloat(index - 1) * 60
                                    let y1 = CGFloat(previousData.previousWeekMinutes) / CGFloat(maxValue) * 120
                                    let x2 = CGFloat(index) * 60
                                    let y2 = CGFloat(data.previousWeekMinutes) / CGFloat(maxValue) * 120
                                    
                                    path.move(to: CGPoint(x: x1, y: y1))
                                    path.addLine(to: CGPoint(x: x2, y: y2))
                                }
                                .stroke(theme.chartLineSecondary, style: StrokeStyle(lineWidth: 2, dash: [4]))
                            }
                            
                            // This Week Line
                            if index > 0 {
                                Path { path in
                                    let previousData = chatData[index - 1]
                                    let x1 = CGFloat(index - 1) * 60
                                    let y1 = CGFloat(previousData.thisWeekMinutes) / CGFloat(maxValue) * 120
                                    let x2 = CGFloat(index) * 60
                                    let y2 = CGFloat(data.thisWeekMinutes) / CGFloat(maxValue) * 120
                                    
                                    path.move(to: CGPoint(x: x1, y: y1))
                                    path.addLine(to: CGPoint(x: x2, y: y2))
                                }
                                .stroke(theme.chartLinePrimary, style: StrokeStyle(lineWidth: 2))
                            }
                            
                            // Data Points
                            Circle()
                                .fill(theme.chartLineSecondary)
                                .frame(width: 6, height: 6)
                                .position(
                                    x: 0,
                                    y: CGFloat(data.previousWeekMinutes) / CGFloat(maxValue) * 120
                                )
                            
                            Circle()
                                .fill(theme.chartLinePrimary)
                                .frame(width: 6, height: 6)
                                .position(
                                    x: 0,
                                    y: CGFloat(data.thisWeekMinutes) / CGFloat(maxValue) * 120
                                )
                            
                            Spacer()
                        }
                        .frame(width: 60)
                        
                        if index < chatData.count - 1 {
                            Spacer()
                        }
                    }
                }
                .frame(height: 120)
            }
            .frame(height: 120)
            
            // X-Axis Labels
            HStack {
                ForEach(chatData, id: \.id) { data in
                    Text(data.date)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(theme.secondaryText)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Bottom Section
            HStack {
                Image(systemName: "bubble.left.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(theme.primaryAccent)
                
                Text("Chatbots")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(theme.primaryText)
                
                Spacer()
            }
            .padding(.top, 8)
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
    let chatData = [
        ChatData(date: "Sep 18", previousWeekMinutes: 18, thisWeekMinutes: 22),
        ChatData(date: "Sep 19", previousWeekMinutes: 15, thisWeekMinutes: 25),
        ChatData(date: "Sep 20", previousWeekMinutes: 20, thisWeekMinutes: 35),
        ChatData(date: "Sep 21", previousWeekMinutes: 22, thisWeekMinutes: 38),
        ChatData(date: "Sep 22", previousWeekMinutes: 21, thisWeekMinutes: 27),
        ChatData(date: "Sep 23", previousWeekMinutes: 19, thisWeekMinutes: 24),
        ChatData(date: "Sep 24", previousWeekMinutes: 16, thisWeekMinutes: 20)
    ]
    
    return Group {
        ChatChartView(chatData: chatData)
            .environment(\.theme, DarkTheme())
            .preferredColorScheme(.dark)
            .padding()
            .background(DarkTheme().primaryBackground)
        
        ChatChartView(chatData: chatData)
            .environment(\.theme, LightTheme())
            .preferredColorScheme(.light)
            .padding()
            .background(LightTheme().primaryBackground)
    }
}

