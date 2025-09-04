//
//  FlowerShape.swift
//  CustomerInquiryApp
//
//  Created by Ayushi Barjatya on 03/09/25.
//


import SwiftUI

struct FlowerShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        let petalCount = 12
        let petalRadius = radius * 0.4
        
        for i in 0..<petalCount {
            let angle = Double(i) * (360.0 / Double(petalCount)) * .pi / 180
            let petalCenter = CGPoint(
                x: center.x + CGFloat(cos(angle)) * radius * 0.6,
                y: center.y + CGFloat(sin(angle)) * radius * 0.6
            )
            path.addEllipse(in: CGRect(
                x: petalCenter.x - petalRadius / 2,
                y: petalCenter.y - petalRadius / 2,
                width: petalRadius,
                height: petalRadius
            ))
        }
        
        // center circle
        path.addEllipse(in: CGRect(
            x: center.x - petalRadius / 2,
            y: center.y - petalRadius / 2,
            width: petalRadius,
            height: petalRadius
        ))
        
        return path
    }
}
struct FloralBackgroundView: View {
    
    var accent: Color = .purple
    var accent_flower: Color = .purple
    
    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            let patternSize: CGFloat = 120
            
            ZStack {
                // Accent background with transparency
                accent.opacity(0.4)
                
                // Flowers that adapt to theme
                ForEach(0..<Int(size.width / patternSize) + 2, id: \.self) { i in
                    ForEach(0..<Int(size.height / patternSize) + 2, id: \.self) { j in
                        FlowerShape()
                            .stroke(accent_flower.opacity(0.1),
                                lineWidth: 1
                            )
                            .frame(width: patternSize, height: patternSize)
                            .position(x: CGFloat(i) * patternSize,
                                      y: CGFloat(j) * patternSize)
                    }
                }
            }
            .clipped()
        }
    }
}
