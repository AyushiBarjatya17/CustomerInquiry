//
//  BrandShowcaseView.swift
//  CustomerInquiryApp
//
//  Created by: [Your Name]
//  Date: [Current Date]
//

import SwiftUI

// MARK: - Brand Model
struct Brand: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let logo: String
    let description: String
    let color: Color
    let gradientColors: [Color]
    let category: String
    let rating: Double
    let isFeatured: Bool
    
    static func == (lhs: Brand, rhs: Brand) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Brand Showcase View
struct BrandShowcaseView: View {
    @Environment(\.theme) var theme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var currentIndex = 0
    @State private var dragOffset: CGFloat = 0
    @State private var isAnimating = false
    @State private var showDetails = false
    @State private var selectedBrand: Brand?
    @State private var showContent = false
    
    let brands: [Brand]
    
    private let timer = Timer.publish(every: 2.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            headerView
            brandCarouselView
        }
        .padding(20)
        .background(backgroundView)
        .shadow(color: theme.shadowColor, radius: 8, x: 0, y: 4)
        .sheet(isPresented: $showDetails) {
            if let brand = selectedBrand {
                BrandDetailView(brand: brand)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2)) {
                showContent = true
            }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            Image(systemName: "star.circle.fill")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(theme.primaryAccent)
            
            Text("Featured Brands")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(theme.primaryText)
            
            Spacer()
            
            indicatorDotsView
        }
    }
    
    // MARK: - Indicator Dots View
    private var indicatorDotsView: some View {
        HStack(spacing: 8) {
            ForEach(0..<min(brands.count, 5), id: \.self) { index in
                Circle()
                    .fill(index == currentIndex ? theme.primaryAccent : theme.secondaryText.opacity(0.3))
                    .frame(width: 8, height: 8)
                    .scaleEffect(index == currentIndex ? 1.2 : 1.0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: currentIndex)
            }
        }
    }
    
    // MARK: - Brand Carousel View
    private var brandCarouselView: some View {
        carouselContent
            .frame(height: (horizontalSizeClass == .regular ? 280.0 : 240.0) + 30)
    }
    
    
    // MARK: - Carousel Content
    private var carouselContent: some View {
        GeometryReader { geometry in
            let cardWidth = horizontalSizeClass == .regular ? 280.0 : 240.0
            let spacing: CGFloat = 16.0
            let totalCardWidth = cardWidth + spacing
            
            HStack(spacing: spacing) {
                ForEach(Array(brands.enumerated()), id: \.element.id) { index, brand in
                    brandCardView(for: brand, at: index)
                        .frame(width: cardWidth)
                }
            }
            .offset(x: -CGFloat(currentIndex) * totalCardWidth + dragOffset)
            .gesture(dragGesture)
            .onReceive(timer) { _ in
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    currentIndex = (currentIndex + 1) % brands.count
                }
            }
        }
    }
    
    // MARK: - Brand Card View
    private func brandCardView(for brand: Brand, at index: Int) -> some View {
        BrandCardView(
            brand: brand,
            isActive: index == currentIndex,
            isAnimating: isAnimating
        )
        .scaleEffect(index == currentIndex ? 1.0 : 0.9)
        .opacity(index == currentIndex ? 1.0 : 0.7)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: currentIndex)
        .onTapGesture {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                selectedBrand = brand
                showDetails = true
            }
        }
    }
    
    // MARK: - Drag Gesture
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = value.translation.width
            }
            .onEnded { value in
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    let threshold: CGFloat = 50.0
                    let cardWidth = horizontalSizeClass == .regular ? 280.0 : 240.0
                    let spacing: CGFloat = 16.0
                    let totalCardWidth = cardWidth + spacing
                    
                    if value.translation.width > threshold && currentIndex > 0 {
                        currentIndex -= 1
                    } else if value.translation.width < -threshold && currentIndex < brands.count - 1 {
                        currentIndex += 1
                    }
                    dragOffset = 0
                }
            }
    }
    
    // MARK: - Background View
    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(theme.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(theme.borderColor, lineWidth: 1)
            )
    }
}

// MARK: - Brand Card View
struct BrandCardView: View {
    @Environment(\.theme) var theme
    let brand: Brand
    let isActive: Bool
    let isAnimating: Bool
    
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 16) {
            // Logo Container with Animation
            ZStack {
                // Background Gradient
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: brand.gradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .scaleEffect(pulseScale)
                    .rotationEffect(.degrees(rotationAngle))
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: pulseScale)
                    .animation(.linear(duration: 8.0).repeatForever(autoreverses: false), value: rotationAngle)
                
                // Logo
                Text(brand.logo)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
            }
            
            // Brand Info
            VStack(spacing: 8) {
                Text(brand.name)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(theme.primaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                Text(brand.description)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(theme.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                // Rating Stars
                HStack(spacing: 2) {
                    ForEach(0..<5, id: \.self) { star in
                        Image(systemName: star < Int(brand.rating) ? "star.fill" : "star")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(star < Int(brand.rating) ? .yellow : theme.secondaryText.opacity(0.3))
                    }
                    
                    Text(String(format: "%.1f", brand.rating))
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(theme.secondaryText)
                        .padding(.leading, 4)
                }
                
                // Category Badge
                Text(brand.category)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(theme.accentText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(brand.color.opacity(0.2))
                    )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isActive ? brand.color : theme.borderColor, lineWidth: isActive ? 2 : 1)
                )
        )
        .shadow(
            color: isActive ? brand.color.opacity(0.3) : theme.shadowColor,
            radius: isActive ? 12 : 4,
            x: 0,
            y: isActive ? 6 : 2
        )
        .overlay(
            // Shimmer Effect
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.clear,
                            Color.white.opacity(0.3),
                            Color.clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .rotationEffect(.degrees(30))
                .offset(x: isActive ? 200 : -200)
                .animation(.linear(duration: 2.0).repeatForever(autoreverses: false), value: isActive)
                .opacity(isActive ? 1.0 : 0.0)
        )
        .onAppear {
            if isActive {
                startAnimations()
            }
        }
        .onChange(of: isActive) { newValue in
            if newValue {
                startAnimations()
            } else {
                stopAnimations()
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.1
        }
        withAnimation(.linear(duration: 10.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
    }
    
    private func stopAnimations() {
        withAnimation(.easeInOut(duration: 0.5)) {
            pulseScale = 1.0
            rotationAngle = 0
        }
    }
}

// MARK: - Brand Detail View
struct BrandDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.theme) var theme
    let brand: Brand
    
    @State private var showContent = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Hero Section
                    VStack(spacing: 20) {
                        // Animated Logo
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: brand.gradientColors,
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                                .scaleEffect(showContent ? 1.0 : 0.8)
                                .animation(.spring(response: 0.8, dampingFraction: 0.6), value: showContent)
                            
                            Text(brand.logo)
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                        }
                        
                        VStack(spacing: 12) {
                            Text(brand.name)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(theme.primaryText)
                                .multilineTextAlignment(.center)
                            
                            Text(brand.description)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(theme.secondaryText)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                        .opacity(showContent ? 1.0 : 0.0)
                        .offset(y: showContent ? 0 : 20)
                        .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2), value: showContent)
                    }
                    .padding(.top, 40)
                    
                    // Details Section
                    VStack(spacing: 16) {
                        DetailRowView(
                            icon: "tag.fill",
                            title: "Category",
                            value: brand.category,
                            color: brand.color
                        )
                        
                        DetailRowView(
                            icon: "star.fill",
                            title: "Rating",
                            value: String(format: "%.1f/5.0", brand.rating),
                            color: .yellow
                        )
                        
                        DetailRowView(
                            icon: "crown.fill",
                            title: "Status",
                            value: brand.isFeatured ? "Featured" : "Standard",
                            color: brand.isFeatured ? .orange : .gray
                        )
                    }
                    .padding(.horizontal, 20)
                    .opacity(showContent ? 1.0 : 0.0)
                    .offset(y: showContent ? 0 : 20)
                    .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.4), value: showContent)
                    
                    Spacer(minLength: 40)
                }
            }
            .background(theme.primaryBackground)
            .navigationTitle("Brand Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            withAnimation {
                showContent = true
            }
        }
    }
}

// MARK: - Detail Row View
struct DetailRowView: View {
    @Environment(\.theme) var theme
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(color)
                .frame(width: 24, height: 24)
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(theme.primaryText)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(theme.secondaryText)
        }
        .padding(.horizontal, 20)
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
}

#Preview {
    let sampleBrands = [
        Brand(
            name: "Apple",
            logo: "🍎",
            description: "Innovation in technology",
            color: .blue,
            gradientColors: [.blue, .purple],
            category: "Technology",
            rating: 4.8,
            isFeatured: true
        ),
        Brand(
            name: "Nike",
            logo: "👟",
            description: "Just Do It",
            color: .orange,
            gradientColors: [.orange, .red],
            category: "Sports",
            rating: 4.6,
            isFeatured: true
        ),
        Brand(
            name: "Starbucks",
            logo: "☕",
            description: "Coffee culture",
            color: .green,
            gradientColors: [.green, .mint],
            category: "Food & Beverage",
            rating: 4.4,
            isFeatured: false
        )
    ]
    
    return Group {
        BrandShowcaseView(brands: sampleBrands)
            .environment(\.theme, DarkTheme())
            .preferredColorScheme(.dark)
            .padding()
            .background(DarkTheme().primaryBackground)
        
        BrandShowcaseView(brands: sampleBrands)
            .environment(\.theme, LightTheme())
            .preferredColorScheme(.light)
            .padding()
            .background(LightTheme().primaryBackground)
    }
}
