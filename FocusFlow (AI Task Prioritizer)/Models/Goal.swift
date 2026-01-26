//
//  Goal.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import Foundation

extension Models {
    enum GoalStatus: String, Codable {
        case active = "active"
        case completed = "completed"
        case paused = "paused"
    }

    struct Goal: Identifiable, Codable {
    let id: UUID
    var userId: UUID
    var title: String
    var description: String?
    var targetValue: Double
    var currentValue: Double
    var unit: String // e.g., "hours", "tasks", "sessions"
    var deadline: Date?
    var status: GoalStatus
    var createdAt: Date
    var updatedAt: Date
    
    var progress: Double {
        guard targetValue > 0 else { return 0 }
        return min(currentValue / targetValue, 1.0)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case title
        case description
        case targetValue = "target_value"
        case currentValue = "current_value"
        case unit
        case deadline
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    }
}
