//
//  ContentView.swift
//  CustomerInquiryApp
//
//  Created by Ayushi Barjatya on 02/09/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var selectedTab = 0
    
    var body: some View {
        Group {
            if horizontalSizeClass == .regular {
                // iPad: Use NavigationSplitView for proper iPad layout
                NavigationSplitView {
                    // Sidebar
                    List {
                        NavigationLink(destination: DashboardView()) {
                            Label("Dashboard", systemImage: "chart.bar.fill")
                        }
                        
                        NavigationLink(destination: ChatView()) {
                            Label("Chat", systemImage: "bubble.left.and.bubble.right.fill")
                        }
                    }
                    .navigationTitle("TORAH AI")
                } detail: {
                    // Default detail view
                    DashboardView()
                }
            } else {
                // iPhone: Use TabView with better integration
                TabView(selection: $selectedTab) {
                    DashboardView()
                        .tabItem {
                            Image(systemName: "chart.bar.fill")
                            Text("Dashboard")
                        }
                        .tag(0)
                    
                    ChatView()
                        .tabItem {
                            Image(systemName: "bubble.left.and.bubble.right.fill")
                            Text("Chat")
                        }
                        .tag(1)
                }
                .accentColor(.purple)
                .onChange(of: selectedTab) { newValue in
                    // Handle tab changes if needed
                    print("Tab changed to: \(newValue)")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
