//
//  Achievement.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import Foundation

enum AchievementType: String, Codable {
    case firstTask = "first_task"
    case streak7Days = "streak_7_days"
    case streak30Days = "streak_30_days"
    case focusScore100 = "focus_score_100"
    case completedTasks50 = "completed_tasks_50"
    case completedTasks100 = "completed_tasks_100"
    case deepWorkMaster = "deep_work_master"
}

struct Achievement: Identifiable, Codable {
    let id: UUID
    var userId: UUID
    var achievementType: AchievementType
    var title: String
    var description: String
    var icon: String
    var earnedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case achievementType = "achievement_type"
        case title
        case description
        case icon
        case earnedAt = "earned_at"
    }
}
