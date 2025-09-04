//
//  Message.swift
//  CustomerInquiryApp
//
//  Created by Ayushi Barjatya on 02/09/25.
//

import SwiftUI

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
    let timestamp = Date()
}



class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = [
        Message(text: "👋 Hello! I am your bot. Type 'Daily Post: Title | Content' to save a post.", isUser: false)
    ]
    @Published var isLoading = false
    @Published var suggestions: [String] = []
    
    private let apiService = APIService()
    
    // Typeahead suggestions based on simple rules
    private let commonSuggestions = [
        "Daily Post: SwiftUI Tips | Use @State for reactive UI updates",
        "Daily Post: iOS Development | Implement proper error handling",
        "Daily Post: Swift Best Practices | Use guard statements for early returns",
        "Daily Post: UI/UX Design | Follow Apple's Human Interface Guidelines",
        "Daily Post: Performance | Use lazy loading for large datasets"
    ]
    
    func updateSuggestions(for input: String) {
        if input.isEmpty {
            suggestions = []
            return
        }
        
        let filtered = commonSuggestions.filter { suggestion in
            suggestion.lowercased().contains(input.lowercased())
        }
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            suggestions = Array(filtered.prefix(3))
        }
    }
    
    func sendMessage(_ text: String) {
        // Add user message with animation
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            messages.append(Message(text: text, isUser: true))
        }
        
        if text.lowercased().starts(with: "daily post") {
            handleDailyPost(text)
        } else {
            // Simulate AI reply with animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    self.messages.append(Message(text: "🤖 Got it: \(text)", isUser: false))
                }
            }
        }
    }
    
    private func handleDailyPost(_ text: String) {
        // Example format: Daily Post: SwiftUI | Use @State for reactive UI
        let parts = text.components(separatedBy: ":")
        guard parts.count > 1 else { return }
        
        let details = parts[1].components(separatedBy: "|")
        guard details.count == 2 else { return }
        
        let title = details[0].trimmingCharacters(in: .whitespaces)
        let content = details[1].trimmingCharacters(in: .whitespaces)
        
        // Show loading state
        isLoading = true
        
        // Use the API service
        Task {
            do {
                let result = try await apiService.insertPost(title: title, content: content)
                await MainActor.run {
                    self.isLoading = false
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        if result.contains("✅ Row added") {
                            self.messages.append(Message(text: "✅ Post saved to sheet!", isUser: false))
                        } else {
                            self.messages.append(Message(text: "⚠️ Failed: \(result)", isUser: false))
                        }
                    }
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        self.messages.append(Message(text: "❌ Error: \(error.localizedDescription)", isUser: false))
                    }
                }
            }
        }
    }
    
    func fetchPosts() async -> [Post] {
        do {
            return try await apiService.fetchPosts()
        } catch {
            print("Error fetching posts: \(error)")
            return []
        }
    }
}

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var inputText = ""
    @State private var showPostsList = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Messages ScrollView
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.messages) { msg in
                            MessageBubble(message: msg)
                                .id(msg.id)
                                .transition(.asymmetric(
                                    insertion: .scale(scale: 0.8).combined(with: .opacity),
                                    removal: .opacity
                                ))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
                .onChange(of: viewModel.messages.count) { _ in
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        proxy.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                    }
                }
            }
            
            // Suggestions
            if !viewModel.suggestions.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Array(viewModel.suggestions.enumerated()), id: \.offset) { index, suggestion in
                            Button(action: {
                                inputText = suggestion
                                viewModel.sendMessage(suggestion)
                                inputText = ""
                                viewModel.suggestions = []
                            }) {
                                Text(suggestion)
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .cornerRadius(16)
                            }
                            .transition(.asymmetric(
                                insertion: .scale(scale: 0.8).combined(with: .opacity).combined(with: .move(edge: .bottom)),
                                removal: .scale(scale: 0.8).combined(with: .opacity)
                            ))
                            .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(Double(index) * 0.1), value: viewModel.suggestions)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.05))
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            // Input area
            VStack(spacing: 0) {
                if viewModel.isLoading {
                    HStack(spacing: 8) {
                        ProgressView()
                            .scaleEffect(0.8)
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        Text("Sending...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity).combined(with: .scale(scale: 0.9)),
                        removal: .move(edge: .bottom).combined(with: .opacity).combined(with: .scale(scale: 0.9))
                    ))
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: viewModel.isLoading)
                }
                
                HStack(spacing: 12) {
                    TextField("Type a message...", text: $inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: inputText) { newValue in
                            viewModel.updateSuggestions(for: newValue)
                        }
                    
                    Button(action: {
                        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                        
                        // Haptic feedback
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.impactOccurred()
                        
                        viewModel.sendMessage(inputText)
                        inputText = ""
                        viewModel.suggestions = []
                    }) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.blue)
                            .cornerRadius(8)
                            .scaleEffect(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.8 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            .background(Color(.systemBackground))
        }
        .navigationTitle("Chat Bot")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showPostsList = true
                }) {
                    Image(systemName: "list.bullet")
                        .foregroundColor(.blue)
                }
            }
        }
        
        .sheet(isPresented: $showPostsList) {
            PostsListView()
        }
        
        .navigationTitle("Chat")
        .navigationBarTitleDisplayMode(.large)
    }
    
}

struct MessageBubble: View {
    let message: Message
    @State private var isAppearing = false
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
                Text(message.text)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(18)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    .scaleEffect(isAppearing ? 1.0 : 0.8)
                    .opacity(isAppearing ? 1.0 : 0.0)
            } else {
                Text(message.text)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .foregroundColor(.primary)
                    .cornerRadius(18)
                    .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
                    .scaleEffect(isAppearing ? 1.0 : 0.8)
                    .opacity(isAppearing ? 1.0 : 0.0)
                Spacer()
            }
        }
        .matchedGeometryEffect(id: message.id, in: namespace)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isAppearing = true
            }
        }
    }
    
    @Namespace private var namespace
}

struct PostsListView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var chatViewModel = ChatViewModel()
    @State private var posts: [Post] = []
    @State private var isLoading = false
    
    var body: some View {
        Group {
            if isLoading {
                VStack {
                    ProgressView()
                        .scaleEffect(1.2)
                    Text("Loading posts...")
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                }
            } else if posts.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "doc.text")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("No posts available")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("Posts will appear here once they're loaded")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            } else {
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        ForEach(posts) { post in
                            PostRowView(post: post)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
            }
        }
        .navigationTitle("Posts")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Done") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    Task {
                        await loadPosts()
                    }
                }) {
                    Image(systemName: "arrow.clockwise")
                }
                .disabled(isLoading)
            }
        }
        .onAppear {
            Task {
                await loadPosts()
            }
        }
    }
    
    private func loadPosts() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let fetchedPosts = try await chatViewModel.fetchPosts()
            await MainActor.run {
                posts = fetchedPosts
            }
        } catch {
            print("Error fetching posts: \(error)")
            await MainActor.run {
                posts = []
            }
        }
    }
}

struct PostRowView: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title
            Text(post.title)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            // Content
            Text(post.content)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(4)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            // Date
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundColor(.blue)
                    Text(post.timestamp, style: .date)
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                
                Text(post.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(minHeight: 160)
    }
}

#Preview {
    ChatView()
}
