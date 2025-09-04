//
//  FloatingParticlesView.swift
//  CustomerInquiryApp
//
//  Created by: [Your Name]
//  Date: [Current Date]
//

import SwiftUI

// MARK: - Floating Particle Model
struct FloatingParticle: Identifiable {
    let id = UUID()
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let color: Color
    let speed: CGFloat
    let opacity: Double
    let direction: ParticleDirection
    
    enum ParticleDirection {
        case up
        case down
        case left
        case right
        case diagonal
    }
}

// MARK: - Global Floating Particles Manager
@MainActor
class FloatingParticlesManager: ObservableObject {
    @Published var particles: [FloatingParticle] = []
    @Published var isEnabled: Bool = true
    
    private var timer: Timer?
    private let maxParticles = 15
    private let colors: [Color] = [.blue, .purple, .orange, .green, .pink, .yellow, .cyan, .mint]
    
    init() {
        startParticleGeneration()
    }
    
    deinit {
//        stopParticleGeneration()
    }
    
    func startParticleGeneration() {
        guard isEnabled else { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { [weak self] _ in
            self?.generateNewParticle()
        }
    }
    
    func stopParticleGeneration() {
        timer?.invalidate()
        timer = nil
    }
    
    func toggleParticles() {
        isEnabled.toggle()
        if isEnabled {
            startParticleGeneration()
        } else {
            stopParticleGeneration()
            particles.removeAll()
        }
    }
    
    private func generateNewParticle() {
        guard particles.count < maxParticles else { return }
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        let directions: [FloatingParticle.ParticleDirection] = [.up, .down, .left, .right, .diagonal]
        let direction = directions.randomElement() ?? .up
        
        let particle = FloatingParticle(
            x: CGFloat.random(in: 0...screenWidth),
            y: CGFloat.random(in: 0...screenHeight),
            size: CGFloat.random(in: 3...8),
            color: colors.randomElement() ?? .blue,
            speed: Double.random(in: 2...6),
            opacity: Double.random(in: 0.1...0.4),
            direction: direction
        )
        
        particles.append(particle)
        
        // Remove particle after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + particle.speed) {
            self.particles.removeAll { $0.id == particle.id }
        }
    }
}

// MARK: - Floating Particles View
struct FloatingParticlesView: View {
    @StateObject private var particlesManager = FloatingParticlesManager()
    @Environment(\.theme) var theme
    
    var body: some View {
        ZStack {
            ForEach(particlesManager.particles) { particle in
                Circle()
                    .fill(particle.color.opacity(particle.opacity))
                    .frame(width: particle.size, height: particle.size)
                    .position(x: particle.x, y: particle.y)
                    .animation(.linear(duration: particle.speed).repeatForever(autoreverses: false), value: particle.y)
            }
        }
        .allowsHitTesting(false) // Allow touches to pass through
        .onAppear {
            particlesManager.startParticleGeneration()
        }
        .onDisappear {
            particlesManager.stopParticleGeneration()
        }
    }
}

// MARK: - App-Wide Floating Particles Overlay
struct AppFloatingParticlesOverlay: View {
    @StateObject private var particlesManager = FloatingParticlesManager()
    @Environment(\.theme) var theme
    
    var body: some View {
        ZStack {
            ForEach(particlesManager.particles) { particle in
                Circle()
                    .fill(particle.color.opacity(particle.opacity))
                    .frame(width: particle.size, height: particle.size)
                    .position(x: particle.x, y: particle.y)
                    .animation(.linear(duration: particle.speed).repeatForever(autoreverses: false), value: particle.y)
            }
        }
        .allowsHitTesting(false)
        .ignoresSafeArea()
        .onAppear {
            particlesManager.startParticleGeneration()
        }
        .onDisappear {
            particlesManager.stopParticleGeneration()
        }
    }
}

// MARK: - Floating Particles Toggle Button
struct FloatingParticlesToggleButton: View {
    @StateObject private var particlesManager = FloatingParticlesManager()
    @Environment(\.theme) var theme
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                particlesManager.toggleParticles()
            }
        }) {
            Image(systemName: particlesManager.isEnabled ? "sparkles" : "sparkles.slash")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(particlesManager.isEnabled ? theme.primaryAccent : theme.secondaryText)
                .scaleEffect(particlesManager.isEnabled ? 1.1 : 1.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: particlesManager.isEnabled)
        }
    }
}

// MARK: - Enhanced Floating Particles (for specific views)
struct EnhancedFloatingParticlesView: View {
    @Environment(\.theme) var theme
    let intensity: ParticleIntensity
    let colors: [Color]
    
    enum ParticleIntensity {
        case light
        case medium
        case heavy
        
        var particleCount: Int {
            switch self {
            case .light: return 5
            case .medium: return 10
            case .heavy: return 20
            }
        }
        
        var speed: ClosedRange<Double> {
            switch self {
            case .light: return 3...5
            case .medium: return 2...4
            case .heavy: return 1...3
            }
        }
    }
    
    @State private var particles: [FloatingParticle] = []
    
    init(intensity: ParticleIntensity = .medium, colors: [Color] = [.blue, .purple, .orange, .green, .pink]) {
        self.intensity = intensity
        self.colors = colors
    }
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color.opacity(particle.opacity))
                    .frame(width: particle.size, height: particle.size)
                    .position(x: particle.x, y: particle.y)
                    .animation(.linear(duration: particle.speed).repeatForever(autoreverses: false), value: particle.y)
            }
        }
        .allowsHitTesting(false)
        .onAppear {
            generateParticles()
        }
    }
    
    private func generateParticles() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        for _ in 0..<intensity.particleCount {
            let particle = FloatingParticle(
                x: CGFloat.random(in: 0...screenWidth),
                y: CGFloat.random(in: 0...screenHeight),
                size: CGFloat.random(in: 2...6),
                color: colors.randomElement() ?? .blue,
                speed: Double.random(in: intensity.speed),
                opacity: Double.random(in: 0.1...0.3),
                direction: .up
            )
            particles.append(particle)
        }
    }
}

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()
        
        VStack {
            Text("Floating Particles Demo")
                .font(.title)
                .foregroundColor(.white)
            
            FloatingParticlesToggleButton()
                .padding()
            
            Spacer()
        }
        
        AppFloatingParticlesOverlay()
    }
}
