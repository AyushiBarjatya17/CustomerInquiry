//
//  APIService.swift
//  CustomerInquiryApp
//
//  Created by Ayushi Barjatya on 02/09/25.
//

import Foundation

// API Response model to match the JSON structure from Google Apps Script
struct APIPost: Codable {
    let date: Date
    let title: String
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case date = "Date"
        case title
        case content
    }
}

class APIService: ObservableObject {
    private let baseURL = "https://script.google.com/macros/s/AKfycbxBCxlPRo1t0CE4ibM0hhujMjhGb63EgPfguNQZhNx4L_P6z43_shQHf2ChralnXwY1/exec"
    private let getPostsURL = "https://script.google.com/macros/s/AKfycbwlhscIlnxBpAhSjondd-FGbNnA4W2xmSIdxjGaHImAGQARkc2OghA1pKF76Kld09X1/exec"
    
    func insertPost(title: String, content: String) async throws -> String {
        let json: [String: Any] = [
            "title": title,
            "content": content
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json) else {
            throw APIError.invalidData
        }
        
        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw APIError.httpError(statusCode: httpResponse.statusCode)
        }
        
        guard let result = String(data: data, encoding: .utf8) else {
            throw APIError.invalidData
        }
        
        print("📤 Insert Post Response: \(result)")
        return result
    }
    
    func fetchPosts() async throws -> [Post] {
        guard let url = URL(string: getPostsURL) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw APIError.httpError(statusCode: httpResponse.statusCode)
        }
        
        // Parse the JSON response from your Google Apps Script
        do {
            let decoder = JSONDecoder()

            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds] // handles 2025-09-02T14:27:17.000Z

            decoder.dateDecodingStrategy = .custom { decoder in
                let container = try decoder.singleValueContainer()
                let dateStr = try container.decode(String.self)
                if let date = formatter.date(from: dateStr) {
                    return date
                }
                throw DecodingError.dataCorruptedError(in: container,
                    debugDescription: "Invalid date format: \(dateStr)")
            }
            
            // Debug: Print the raw response
            if let responseString = String(data: data, encoding: .utf8) {
                print("📡 API Response: \(responseString)")
            }
            
            // The API returns an array of posts with Date, title, and content
            let posts = try decoder.decode([APIPost].self, from: data)
            
            print("✅ Successfully decoded \(posts.count) posts")
            
            // Convert API posts to our Post model
            return posts.map { apiPost in
                Post(title: apiPost.title, content: apiPost.content, timestamp: apiPost.date)
            }
        } catch {
            print("❌ JSON Decoding Error: \(error)")
            print("❌ Error details: \(error.localizedDescription)")
            throw APIError.invalidData
        }
    }
}

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidData
    case invalidResponse
    case httpError(statusCode: Int)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL format"
        case .invalidData:
            return "Invalid data format"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let statusCode):
            return "HTTP error: \(statusCode)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}
