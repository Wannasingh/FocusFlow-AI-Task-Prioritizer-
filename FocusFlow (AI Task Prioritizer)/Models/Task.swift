//
//  Task.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import Foundation

enum TaskPriority: String, Codable, CaseIterable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    case urgent = "urgent"
}

enum TaskStatus: String, Codable, CaseIterable {
    case todo = "todo"
    case inProgress = "in_progress"
    case completed = "completed"
    case scheduled = "scheduled"
    
    var displayName: String {
        switch self {
        case .todo: return "To Do"
        case .inProgress: return "In Progress"
        case .completed: return "Completed"
        case .scheduled: return "Scheduled"
        }
    }
}

enum TaskCategory: String, Codable, CaseIterable {
    case work = "work"
    case personal = "personal"
    case health = "health"
    case learning = "learning"
    case creative = "creative"
    case marketing = "marketing"
    case dev = "dev"
    
    var color: String {
        switch self {
        case .work: return "cyan"
        case .personal: return "magenta"
        case .health: return "purple"
        case .learning: return "orange"
        case .creative: return "yellow"
        case .marketing: return "pink"
        case .dev: return "orange"
        }
    }
}

struct Task: Identifiable, Codable {
    let id: UUID
    var userId: UUID
    var title: String
    var description: String?
    var priority: TaskPriority
    var status: TaskStatus
    var category: TaskCategory
    var dueDate: Date?
    var estimatedTime: Int? // in minutes
    var actualTime: Int? // in minutes
    var aiPriorityScore: Double?
    var createdAt: Date
    var updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case title
        case description
        case priority
        case status
        case category
        case dueDate = "due_date"
        case estimatedTime = "estimated_time"
        case actualTime = "actual_time"
        case aiPriorityScore = "ai_priority_score"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
