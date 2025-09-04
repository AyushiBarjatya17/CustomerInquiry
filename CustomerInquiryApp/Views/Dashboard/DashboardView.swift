//
//  DashboardView.swift
//  CustomerInquiryApp
//
//  Created by Ayushi Barjatya on 02/09/25.
//

import SwiftUI

// MARK: - Dashboard Models
struct DashboardEvent: Identifiable {
    let id = UUID()
    let title: String
    let dates: String
    let backgroundColor: String
    let patternColor: String
}

struct DashboardStat: Identifiable {
    let id = UUID()
    let icon: String
    let value: String
    let label: String
}

struct ChatData: Identifiable {
    let id = UUID()
    let date: String
    let previousWeekMinutes: Int
    let thisWeekMinutes: Int
}

struct RecentChat: Identifiable {
    let id = UUID()
    let avatar: String
    let name: String
    let description: String
    let avatarColor: String
}

struct UserProfile {
    let name: String
    let avatar: String
}

enum TimeFrame: String, CaseIterable {
    case year = "Year"
    case month = "Month"
    case week = "Week"
}

// MARK: - Dashboard ViewModel
@MainActor
class DashboardViewModel: ObservableObject {
    @Published var events: [DashboardEvent] = []
    @Published var stats: [DashboardStat] = []
    @Published var chatData: [ChatData] = []
    @Published var recentChats: [RecentChat] = []
    @Published var userProfile = UserProfile(name: "Jonathan Smith", avatar: "person.circle")
    @Published var selectedTimeFrame: TimeFrame = .week
    @Published var showChatView = false
    @Published var showPostsList = false
    @Published var showCustomerList = false
    @Published var showNotification = false
    @Published var notificationMessage = ""
    
    init() {
        loadDashboardData()
    }
    
    private func loadDashboardData() {
        events = [
            DashboardEvent(
                title: "Yom Kippur",
                dates: "Sunset of Sun, September 24 - Nightfall of Mon, September 25",
                backgroundColor: "purple",
                patternColor: "purpleLight"
            ),
            DashboardEvent(
                title: "Hanukkah",
                dates: "Sunset of Sun, November 28 - Nightfall of Mon, December 6",
                backgroundColor: "blue",
                patternColor: "blueLight"
            ),
            DashboardEvent(
                title: "Passover (Pesach)",
                dates: "Sunset of Fri, April 15 - Nightfall of Sat, April 23",
                backgroundColor: "orange",
                patternColor: "orangeLight"
            )
        ]
        
        stats = [
            DashboardStat(icon: "brain.head.profile", value: "12", label: "chatbots used"),
            DashboardStat(icon: "questionmark.bubble", value: "259", label: "questions asked"),
            DashboardStat(icon: "hourglass", value: "15m 26s", label: "avg chat duration"),
            DashboardStat(icon: "stopwatch", value: "4s", label: "avg response time")
        ]
        
        chatData = [
            ChatData(date: "Sep 18", previousWeekMinutes: 18, thisWeekMinutes: 22),
            ChatData(date: "Sep 19", previousWeekMinutes: 15, thisWeekMinutes: 25),
            ChatData(date: "Sep 20", previousWeekMinutes: 20, thisWeekMinutes: 35),
            ChatData(date: "Sep 21", previousWeekMinutes: 22, thisWeekMinutes: 38),
            ChatData(date: "Sep 22", previousWeekMinutes: 21, thisWeekMinutes: 27),
            ChatData(date: "Sep 23", previousWeekMinutes: 19, thisWeekMinutes: 24),
            ChatData(date: "Sep 24", previousWeekMinutes: 16, thisWeekMinutes: 20)
        ]
        
        recentChats = [
            RecentChat(avatar: "V", name: "Va'etchanan", description: "Chumash / Devarim", avatarColor: "purple"),
            RecentChat(avatar: "S", name: "Shabbat", description: "Talmud / Seder Moed", avatarColor: "blue"),
            RecentChat(avatar: "G", name: "GPT-4", description: "Generic chatbots", avatarColor: "green"),
            RecentChat(avatar: "B", name: "Bereshit", description: "Lech Lecha", avatarColor: "orange")
        ]
    }
    
    func onChatbotTapped() {
        showChatView = true
        notificationMessage = "🤖 Chatbot activated! Opening chat interface..."
        showNotification = true
        
        // Auto-hide notification after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showNotification = false
        }
        
        // On iPhone, this will show the chat sheet
        // On iPad, this will show the chat sheet
        // Both provide immediate access to the chatbot
    }
    
    func onListTapped() {
        showPostsList = true
    }
    
    func onEventChatTapped(_ event: DashboardEvent) {
        showChatView = true
    }
    
    func onRecentChatTapped(_ chat: RecentChat) {
        showChatView = true
    }
    
    func onSeeAllCustomersTapped() {
        showCustomerList = true
    }
    
    func onTimeFrameChanged(_ timeFrame: TimeFrame) {
        selectedTimeFrame = timeFrame
    }
}

// MARK: - Dashboard View
struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.theme) var theme
    
    var body: some View {
        ScrollView {
          VStack(spacing: horizontalSizeClass == .regular ? 24 : 16) {
            // Top Bar
            DashboardTopBar(viewModel: viewModel)
            
            // Main Content
            mainContent
        }
            .padding(.horizontal, horizontalSizeClass == .regular ? 32 : 16)
            .padding(.vertical, horizontalSizeClass == .regular ? 24 : 12)
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
                .presentationDetents(horizontalSizeClass == .regular ? [.large] : [.large])
                .presentationDragIndicator(.visible)
        }
        .overlay(
            // Notification Toast
            VStack {
                if viewModel.showNotification {
                    HStack {
                        Text(viewModel.notificationMessage)
                            .font(horizontalSizeClass == .regular ? .subheadline : .caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, horizontalSizeClass == .regular ? 16 : 12)
                            .padding(.vertical, horizontalSizeClass == .regular ? 12 : 8)
                            .background(Color.green)
                            .cornerRadius(horizontalSizeClass == .regular ? 25 : 20)
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: viewModel.showNotification)
                    .padding(.top, horizontalSizeClass == .regular ? 50 : 40)
                    
                    Spacer()
                }
            }
        )
    }
    
    // MARK: - Main Content
    private var mainContent: some View {
        VStack(spacing: horizontalSizeClass == .regular ? 24 : 12) {
            // Event Cards Row
            eventCardsRow
            
            // Statistics Cards Row
            statisticsCardsRow
            
            // Charts and Recent Chats Row
            chartsAndChatsRow
        }
    }
    
    // MARK: - Event Cards Row
    private var eventCardsRow: some View {
        Group {
            if horizontalSizeClass == .regular {
                // iPad: 3 columns
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3), spacing: 16) {
                    ForEach(viewModel.events) { event in
                        EventCardView(event: event) {
                            viewModel.onEventChatTapped(event)
                        }
                    }
                }
            } else {
                // iPhone: Horizontal slider
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(viewModel.events) { event in
                            EventCardView(event: event) {
                                viewModel.onEventChatTapped(event)
                            }
                            .frame(width: 280) // Fixed width for consistent slider appearance
                        }
                    }
                   
                }
            }
        }
    }
    
    // MARK: - Statistics Cards Row
    private var statisticsCardsRow: some View {
        Group {
            if horizontalSizeClass == .regular {
                                 // iPad: 2x2 grid for better horizontal card layout
                 LazyVGrid(columns: [
                     GridItem(.flexible(), spacing: 16),
                     GridItem(.flexible(), spacing: 16)
                 ], spacing: 16) {
                     ForEach(viewModel.stats) { stat in
                         StatCardView(stat: stat)
                     }
                 }
            } else {
                // iPhone: 2x2 grid for better space utilization
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 8),
                    GridItem(.flexible(), spacing: 8)
                ], spacing: 8) {
                    ForEach(viewModel.stats) { stat in
                        StatCardView(stat: stat)
                    }
                }
            }
        }
    }
    
    // MARK: - Charts and Recent Chats Row
    private var chartsAndChatsRow: some View {
        Group {
            if horizontalSizeClass == .regular {
                // iPad: Side by side
                HStack(spacing: 24) {
                    ChattingStatisticsView(viewModel: viewModel)
                        .frame(maxWidth: .infinity)
                    
                                         RecentCustomerListView(recentCustomers: viewModel.recentChats, onCustomerTapped: { chat in
                         viewModel.onRecentChatTapped(chat)
                     }, onSeeAllTapped: {
                         viewModel.onSeeAllCustomersTapped()
                     })
                     .frame(maxWidth: .infinity)
                }
            } else {
                // iPhone: Stacked with compact spacing
                VStack(spacing: 12) {
                    ChattingStatisticsView(viewModel: viewModel)
                                         RecentCustomerListView(recentCustomers: viewModel.recentChats, onCustomerTapped: { chat in
                         viewModel.onRecentChatTapped(chat)
                     }, onSeeAllTapped: {
                         viewModel.onSeeAllCustomersTapped()
                     })
                }
            }
        }
    }
}

// MARK: - Dashboard Components

// MARK: - Top Bar
struct DashboardTopBar: View {
    @Environment(\.theme) var theme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    let viewModel: DashboardViewModel
    
    var body: some View {
        Group {
            if horizontalSizeClass == .regular {
                // iPad Layout
                HStack {
                    // Left side - Logo and Welcome
                    HStack(spacing: 16) {
                        // TORAH AI Logo
                        TorahLogoView()
                        
                        Spacer()
                        
                        Text("Welcome, \(viewModel.userProfile.name)!")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(theme.primaryText)
                    }
                    
                    Spacer()
                    
                    // Right side - Theme Toggle and User Profile
                    HStack(spacing: 16) {
                        // Theme Toggle
                        ThemeToggleButton()
                        
                        // User Profile
                        UserProfileView(
                            userName: viewModel.userProfile.name,
                            userAvatar: viewModel.userProfile.avatar
                        )
                    }
                }
                .padding(24)
                .padding(.vertical, 20)
            } else {
                // iPhone Layout - Stacked for better space management
                VStack(spacing: 12) {
                    // Top row - Logo and Theme Toggle
                    HStack {
                        // TORAH AI Logo
                        TorahLogoView()
                        
                        Spacer()
                        
                        // Theme Toggle
                        ThemeToggleButton()
                    }
                    
                    // Bottom row - User Profile
                    HStack {
                        Spacer()
                        
                        // User Profile (simplified for iPhone)
                        Button(action: {
                            // User profile action
                        }) {
                            HStack(spacing: 8) {
                                // Avatar
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [theme.primaryAccent, theme.secondaryAccent],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 32, height: 32)
                                    
                                    Text(String(viewModel.userProfile.name.prefix(1)))
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(theme.accentText)
                                }
                                
                                // User Name (horizontal on iPhone)
                                Text(viewModel.userProfile.name)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(theme.primaryText)
                                
                                // Dropdown Arrow
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(theme.secondaryText)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(16)
                .padding(.vertical, 12)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.secondaryBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(theme.borderColor, lineWidth: 1)
                )
        )
        .cornerRadius(16)
        .shadow(color: theme.shadowColor, radius: 4, x: 0, y: 2)
    }
}

// MARK: - Event Card (using themed component)

// MARK: - Stat Card (using themed component)

// MARK: - Chatting Statistics View
struct ChattingStatisticsView: View {
    @ObservedObject var viewModel: DashboardViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                Image(systemName: "chart.bar")
                    .font(.title2)
                    .foregroundColor(.purple)
                
                Text("Chatting Statistics")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            // Legend
            HStack(spacing: 16) {
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.purple.opacity(0.6))
                        .frame(width: 8, height: 8)
                    
                    Text("Previous week")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.purple)
                        .frame(width: 8, height: 8)
                    
                    Text("This week")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Time frame selector
            HStack(spacing: 8) {
                ForEach(TimeFrame.allCases, id: \.self) { timeFrame in
                    Button(action: {
                        viewModel.onTimeFrameChanged(timeFrame)
                    }) {
                        Text(timeFrame.rawValue)
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                viewModel.selectedTimeFrame == timeFrame 
                                    ? Color.purple 
                                    : Color(.systemGray5)
                            )
                            .foregroundColor(
                                viewModel.selectedTimeFrame == timeFrame 
                                    ? .white 
                                    : .primary
                            )
                            .cornerRadius(16)
                    }
                }
            }
            
            // Chart
            ChartView(chatData: viewModel.chatData)
                .frame(height: 200)
        }
        .padding(20)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

// MARK: - Chart View
struct ChartView: View {
    let chatData: [ChatData]
    
    var body: some View {
        GeometryReader { geometry in
            let maxValue = max(
                chatData.map { $0.previousWeekMinutes }.max() ?? 0,
                chatData.map { $0.thisWeekMinutes }.max() ?? 0
            )
            let width = geometry.size.width / CGFloat(chatData.count)
            
            ZStack {
                // Grid lines
                VStack(spacing: 0) {
                    ForEach(0..<5) { i in
                        Divider()
                            .opacity(0.3)
                        Spacer()
                    }
                    Divider()
                        .opacity(0.3)
                }
                
                // Chart lines
                Path { path in
                    for (index, data) in chatData.enumerated() {
                        let x = CGFloat(index) * width + width / 2
                        let y = geometry.size.height - (CGFloat(data.previousWeekMinutes) / CGFloat(maxValue)) * geometry.size.height
                        
                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(Color.purple.opacity(0.6), style: StrokeStyle(lineWidth: 2, dash: [5, 5]))
                
                Path { path in
                    for (index, data) in chatData.enumerated() {
                        let x = CGFloat(index) * width + width / 2
                        let y = geometry.size.height - (CGFloat(data.thisWeekMinutes) / CGFloat(maxValue)) * geometry.size.height
                        
                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(Color.purple, lineWidth: 3)
                
                // Data points
                ForEach(Array(chatData.enumerated()), id: \.element.id) { index, data in
                    let x = CGFloat(index) * width + width / 2
                    let y = geometry.size.height - (CGFloat(data.thisWeekMinutes) / CGFloat(maxValue)) * geometry.size.height
                    
                    Circle()
                        .fill(Color.purple)
                        .frame(width: 8, height: 8)
                        .position(x: x, y: y)
                }
                
                // X-axis labels
                VStack {
                    Spacer()
                    HStack(spacing: 0) {
                        ForEach(chatData, id: \.id) { data in
                            Text(data.date)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .frame(width: width)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Recent Chats View (using themed component)

// MARK: - Recent Chat Row (using themed component)

#Preview {
    DashboardView()
}
