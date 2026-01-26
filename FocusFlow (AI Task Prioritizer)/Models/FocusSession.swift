//
//  FocusSession.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import Foundation

extension Models {
    enum SessionType: String, Codable {
        case pomodoro = "pomodoro"
        case deepWork = "deep_work"
        case shortBreak = "short_break"
        case longBreak = "long_break"
    }

    struct FocusSession: Identifiable, Codable {
    let id: UUID
    var userId: UUID
    var taskId: UUID?
    var startTime: Date
    var endTime: Date?
    var durationMinutes: Int?
    var sessionType: SessionType
    var createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case taskId = "task_id"
        case startTime = "start_time"
        case endTime = "end_time"
        case durationMinutes = "duration_minutes"
        case sessionType = "session_type"
        case createdAt = "created_at"
    }
    }
}
