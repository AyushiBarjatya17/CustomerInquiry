//
//  Models.swift
//  CustomerInquiryApp
//
//  Created by Ayushi Barjatya on 02/09/25.
//

import Foundation

struct Post: Identifiable, Codable {
    let id = UUID()
    let title: String
    let content: String
    let timestamp: Date

    enum CodingKeys: String, CodingKey {
        case title
        case content
        case timestamp = "Date" // map JSON "Date" -> Swift property "timestamp"
    }
}
