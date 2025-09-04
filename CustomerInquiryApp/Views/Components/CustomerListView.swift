//
//  CustomerListView.swift
//  CustomerInquiryApp
//
//  Created by: [Your Name]
//  Date: [Current Date]
//

import SwiftUI

// MARK: - Customer List ViewModel
@MainActor
class CustomerListViewModel: ObservableObject {
    @Published var customers: [Post] = []
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var hasMoreData = true
    @Published var currentPage = 1
    @Published var errorMessage: String?
    
    private let apiService = APIService()
    private let pageSize = 20
    
    init() {
        loadCustomers()
    }
    
    func loadCustomers() {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedCustomers = try await apiService.fetchPosts()
                await MainActor.run {
                    self.customers = fetchedCustomers
                    self.isLoading = false
                    self.hasMoreData = fetchedCustomers.count >= self.pageSize
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func loadMoreCustomers() {
        guard !isLoadingMore && hasMoreData else { return }
        
        isLoadingMore = true
        
        Task {
            do {
                // For now, we'll fetch all data again since the API doesn't support pagination
                // In a real implementation, you would modify the API to support page parameters
                let fetchedCustomers = try await apiService.fetchPosts()
                await MainActor.run {
                    // Simulate pagination by taking a subset
                    let startIndex = self.customers.count
                    let endIndex = min(startIndex + self.pageSize, fetchedCustomers.count)
                    
                    if startIndex < fetchedCustomers.count {
                        let newCustomers = Array(fetchedCustomers[startIndex..<endIndex])
                        self.customers.append(contentsOf: newCustomers)
                    }
                    
                    self.isLoadingMore = false
                    self.hasMoreData = endIndex < fetchedCustomers.count
                }
            } catch {
                await MainActor.run {
                    self.isLoadingMore = false
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func refreshCustomers() {
        currentPage = 1
        customers.removeAll()
        hasMoreData = true
        loadCustomers()
    }
}

// MARK: - Customer List View
struct CustomerListView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.theme) var theme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @StateObject private var viewModel = CustomerListViewModel()
    
    var body: some View {
        Group {
            if horizontalSizeClass == .regular {
                // iPad: Sidebar presentation
                HStack(spacing: 0) {
                    // Left Sidebar - Customer List
                    VStack(spacing: 0) {
                        // Header
                        HStack {
                            Text("Customers")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(theme.primaryText)
                            
                            Spacer()
                            
                            Button(action: {
                                viewModel.refreshCustomers()
                            }) {
                                Image(systemName: "arrow.clockwise")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(theme.primaryAccent)
                            }
                            .disabled(viewModel.isLoading)
                            
                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(theme.primaryAccent)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(theme.secondaryBackground)
                        
                        // Filter Dropdown
                        HStack {
                            Text("All Customers")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(theme.primaryText)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.down")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(theme.secondaryText)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(theme.cardBackground)
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(theme.borderColor),
                            alignment: .bottom
                        )
                        
                        // Customer List
                        customerListContent
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                    }
                    .frame(width: 350)
                    .background(theme.primaryBackground)
                    .overlay(
                        Rectangle()
                            .frame(width: 1)
                            .foregroundColor(theme.borderColor),
                        alignment: .trailing
                    )
                    
                    // Right Detail View
                    VStack {
                        Image(systemName: "person.2.circle")
                            .font(.system(size: 80))
                            .foregroundColor(theme.secondaryText)
                        
                        Text("Select a customer to view details")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(theme.primaryText)
                            .padding(.top, 20)
                        
                        Text("Customer information and order history will appear here")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(theme.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.top, 8)
                            .padding(.horizontal, 40)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(theme.primaryBackground)
                }
            } else {
                // iPhone: Full screen navigation
                NavigationStack {
                    iPhoneCustomerListContent
                        .navigationTitle("All Customers")
                        .navigationBarTitleDisplayMode(.large)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Close") {
                                    dismiss()
                                }
                            }
                            
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    viewModel.refreshCustomers()
                                }) {
                                    Image(systemName: "arrow.clockwise")
                                }
                                .disabled(viewModel.isLoading)
                            }
                        }
                }
            }
        }
        .background(theme.primaryBackground)
    }
    
    // MARK: - iPhone Customer List Content
    private var iPhoneCustomerListContent: some View {
        Group {
            if viewModel.isLoading && viewModel.customers.isEmpty {
                // Initial loading state
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.2)
                    Text("Loading customers...")
                        .font(.headline)
                        .foregroundColor(theme.secondaryText)
                }
            } else if viewModel.customers.isEmpty && viewModel.errorMessage != nil {
                // Error state
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.red)
                    
                    Text("Failed to load customers")
                        .font(.headline)
                        .foregroundColor(theme.primaryText)
                    
                    Text(viewModel.errorMessage ?? "Unknown error")
                        .font(.subheadline)
                        .foregroundColor(theme.secondaryText)
                        .multilineTextAlignment(.center)
                    
                    Button("Retry") {
                        viewModel.refreshCustomers()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            } else if viewModel.customers.isEmpty {
                // Empty state
                VStack(spacing: 16) {
                    Image(systemName: "person.2")
                        .font(.system(size: 50))
                        .foregroundColor(theme.secondaryText)
                    
                    Text("No customers found")
                        .font(.headline)
                        .foregroundColor(theme.primaryText)
                    
                    Text("Customers will appear here once they're loaded")
                        .font(.subheadline)
                        .foregroundColor(theme.secondaryText)
                        .multilineTextAlignment(.center)
                }
                .padding()
            } else {
                // Customer list
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.customers) { customer in
                            CustomerRowView(customer: customer)
                                .onAppear {
                                    // Load more when reaching the last few items
                                    if customer.id == viewModel.customers.last?.id {
                                        viewModel.loadMoreCustomers()
                                    }
                                }
                        }
                        
                        // Loading more indicator
                        if viewModel.isLoadingMore {
                            HStack {
                                ProgressView()
                                    .scaleEffect(0.8)
                                Text("Loading more...")
                                    .font(.caption)
                                    .foregroundColor(theme.secondaryText)
                            }
                            .padding()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
            }
        }
    }
    
    // MARK: - Customer List Content (for iPad sidebar)
    private var customerListContent: some View {
        Group {
                if viewModel.isLoading && viewModel.customers.isEmpty {
                    // Initial loading state
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.2)
                        Text("Loading customers...")
                            .font(.headline)
                            .foregroundColor(theme.secondaryText)
                    }
                } else if viewModel.customers.isEmpty && viewModel.errorMessage != nil {
                    // Error state
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.red)
                        
                        Text("Failed to load customers")
                            .font(.headline)
                            .foregroundColor(theme.primaryText)
                        
                        Text(viewModel.errorMessage ?? "Unknown error")
                            .font(.subheadline)
                            .foregroundColor(theme.secondaryText)
                            .multilineTextAlignment(.center)
                        
                        Button("Retry") {
                            viewModel.refreshCustomers()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                } else if viewModel.customers.isEmpty {
                    // Empty state
                    VStack(spacing: 16) {
                        Image(systemName: "person.2")
                            .font(.system(size: 50))
                            .foregroundColor(theme.secondaryText)
                        
                        Text("No customers found")
                            .font(.headline)
                            .foregroundColor(theme.primaryText)
                        
                        Text("Customers will appear here once they're loaded")
                            .font(.subheadline)
                            .foregroundColor(theme.secondaryText)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    // Customer list
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(viewModel.customers) { customer in
                                SidebarCustomerRowView(customer: customer)
                                    .onAppear {
                                        // Load more when reaching the last few items
                                        if customer.id == viewModel.customers.last?.id {
                                            viewModel.loadMoreCustomers()
                                        }
                                    }
                            }
                            
                            // Loading more indicator
                            if viewModel.isLoadingMore {
                                HStack {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                    Text("Loading more...")
                                        .font(.caption)
                                        .foregroundColor(theme.secondaryText)
                                }
                                .padding()
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
    }
}

// MARK: - Sidebar Customer Row View
struct SidebarCustomerRowView: View {
    @Environment(\.theme) var theme
    let customer: Post
    @State private var isSelected = false
    
    var body: some View {
        HStack(spacing: 12) {
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
                    .frame(width: 40, height: 40)
                
                Text(String(customer.title.prefix(1)).uppercased())
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(theme.accentText)
            }
            
            // Customer Info
            VStack(alignment: .leading, spacing: 2) {
                Text(customer.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(theme.primaryText)
                    .lineLimit(1)
                
                Text(customer.content)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(theme.secondaryText)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // Status indicator (like table number in the reference)
            VStack(spacing: 2) {
                Circle()
                    .fill(theme.primaryAccent)
                    .frame(width: 8, height: 8)
                
                Text("Active")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(theme.secondaryText)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isSelected ? theme.cardBackground.opacity(0.8) : theme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? theme.primaryAccent : theme.borderColor, lineWidth: isSelected ? 2 : 1)
                )
        )
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                isSelected.toggle()
            }
        }
    }
}

// MARK: - Customer Row View (for iPhone)
struct CustomerRowView: View {
    @Environment(\.theme) var theme
    let customer: Post
    
    var body: some View {
        HStack(spacing: 16) {
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
                    .frame(width: 48, height: 48)
                
                Text(String(customer.title.prefix(1)).uppercased())
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(theme.accentText)
            }
            
            // Customer Info
            VStack(alignment: .leading, spacing: 4) {
                Text(customer.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(theme.primaryText)
                    .lineLimit(1)
                
                Text(customer.content)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(theme.secondaryText)
                    .lineLimit(2)
                
                Text(customer.timestamp, style: .relative)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(theme.secondaryText)
            }
            
            Spacer()
            
            // Customer Icon
            Image(systemName: "person.circle.fill")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(theme.primaryAccent)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(theme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(theme.borderColor, lineWidth: 1)
                )
        )
        .shadow(color: theme.shadowColor, radius: 2, x: 0, y: 1)
    }
}

#Preview {
    CustomerListView()
        .environment(\.theme, DarkTheme())
        .preferredColorScheme(.dark)
}

