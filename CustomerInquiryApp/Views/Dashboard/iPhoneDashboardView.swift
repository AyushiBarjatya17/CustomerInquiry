//
//  iPhoneDashboardView.swift
//  CustomerInquiryApp
//
//  Created by: [Your Name]
//  Date: [Current Date]
//

import SwiftUI

struct iPhoneDashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    @Environment(\.theme) var theme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Top Bar
                iPhoneDashboardTopBar(viewModel: viewModel)
                
                // Welcome Message (now integrated in top bar)
                
                // Brand Showcase
                brandShowcaseSection
                
                // Event Cards
                eventCardsSection
                
                // Statistics Cards
                statisticsSection
                
                // Charts and Recent Chats
                chartsAndChatsSection
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .background(theme.primaryBackground)
        .navigationTitle("Dashboard")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $viewModel.showChatView) {
            ChatView()
        }
        .sheet(isPresented: $viewModel.showPostsList) {
            PostsListView()
        }
        .sheet(isPresented: $viewModel.showCustomerList) {
            CustomerListView()
        }
        .overlay(
            // Notification Toast
            VStack {
                if viewModel.showNotification {
                    HStack {
                        Text(viewModel.notificationMessage)
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.green)
                            .cornerRadius(25)
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: viewModel.showNotification)
                    .padding(.top, 50)
                    
                    Spacer()
                }
            }
        )
    }
    
    // MARK: - Welcome Message (now integrated in top bar)
    
    // MARK: - Brand Showcase Section
    private var brandShowcaseSection: some View {
        BrandShowcaseView(brands: viewModel.brands)
    }
    
    // MARK: - Event Cards Section
    private var eventCardsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Upcoming Events")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(theme.primaryText)
                
                Spacer()
            }
            
            VStack(spacing: 10) {
                ForEach(viewModel.events) { event in
                    EventCardView(event: event) {
                        viewModel.onEventChatTapped(event)
                    }
                }
            }
        }
    }
    
    // MARK: - Statistics Section
    private var statisticsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Key Statistics")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(theme.primaryText)
                
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 6),
                GridItem(.flexible(), spacing: 6)
            ], spacing: 6) {
                ForEach(viewModel.stats) { stat in
                    StatCardView(stat: stat)
                }
            }
        }
    }
    
    // MARK: - Charts and Recent Chats Section
    private var chartsAndChatsSection: some View {
        VStack(spacing: 12) {
            // Chat Chart
            ChatChartView(chatData: viewModel.chatData)
            
            // Recent Customers
            RecentCustomerListView(recentCustomers: viewModel.recentChats, onCustomerTapped: { chat in
                viewModel.onRecentChatTapped(chat)
            }, onSeeAllTapped: {
                viewModel.onSeeAllCustomersTapped()
            })
        }
    }
}

// MARK: - iPhone Dashboard Top Bar
struct iPhoneDashboardTopBar: View {
    @Environment(\.theme) var theme
    let viewModel: DashboardViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            // Left Side: Logo and Welcome
            HStack(spacing: 12) {
                // TORAH AI Logo (Compact)
                TorahLogoView()
                
                // Welcome Message
                VStack(alignment: .leading, spacing: 2) {
                    Text("Welcome, \(viewModel.userProfile.name)!")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(theme.primaryText)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            // Right Side: Theme Toggle and User Profile
            HStack(spacing: 12) {
                // Theme Toggle
                ThemeToggleButton()
                
                // Floating Particles Toggle
                FloatingParticlesToggleButton()
                
                // User Profile
                UserProfileView(
                    userName: viewModel.userProfile.name,
                    userAvatar: viewModel.userProfile.avatar
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.secondaryBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(theme.borderColor, lineWidth: 1)
                )
        )
        .shadow(color: theme.shadowColor, radius: 4, x: 0, y: 2)
    }
}


#Preview {
    NavigationView {
        iPhoneDashboardView()
            .environment(\.theme, DarkTheme())
            .preferredColorScheme(.dark)
    }
}
