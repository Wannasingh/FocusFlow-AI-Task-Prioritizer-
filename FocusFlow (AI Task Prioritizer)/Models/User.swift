//
//  User.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import Foundation

extension Models {
    struct User: Identifiable, Codable {
    let id: UUID
    var email: String
    var displayName: String
    var avatarURL: String?
    var focusScore: Int?
    var createdAt: Date?
    var updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case displayName = "display_name"
        case avatarURL = "avatar_url"
        case focusScore = "focus_score"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    }
}
