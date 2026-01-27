//
//  TaskViewModel.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by Antigravity on 27/1/2569 BE.
//

import Foundation
import SwiftUI
import Combine

class TaskViewModel: ObservableObject {
    @Published var tasks: [Models.Task] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let aiService = AIService.shared
    
    // In a real app, you would inject a TaskService here to talk to Supabase
    // For now, we'll implement a placeholder for task creation and AI analysis
    
    func createTask(
        title: String,
        description: String?,
        category: Models.TaskCategory,
        dueDate: Date?,
        priority: Models.TaskPriority
    ) async {
        await MainActor.run { isLoading = true }
        
        do {
            // 1. Analyze priority with AI
            let aiScore = try await aiService.analyzeTaskPriority(
                title: title,
                description: description,
                category: category.rawValue,
                dueDate: dueDate
            )
            
            // 2. Create the task object
            let newTask = Models.Task(
                id: UUID(),
                userId: UUID(), // This would come from AuthService
                title: title,
                description: description,
                priority: priority,
                status: .todo,
                category: category,
                dueDate: dueDate,
                estimatedTime: nil,
                actualTime: nil,
                aiPriorityScore: aiScore,
                createdAt: Date(),
                updatedAt: Date()
            )
            
            await MainActor.run {
                self.tasks.append(newTask)
                self.isLoading = false
            }
            
            // 3. Save to Supabase (Omitted for this step, but would use TaskService)
            print("Task created with AI Priority Score: \(aiScore)")
            
        } catch {
            await MainActor.run {
                self.error = error
                self.isLoading = false
            }
            print("Failed to analyze task with AI: \(error.localizedDescription)")
            
            // Fallback: Create task without AI score
            let newTask = Models.Task(
                id: UUID(),
                userId: UUID(),
                title: title,
                description: description,
                priority: priority,
                status: .todo,
                category: category,
                dueDate: dueDate,
                estimatedTime: nil,
                actualTime: nil,
                aiPriorityScore: nil,
                createdAt: Date(),
                updatedAt: Date()
            )
            
            await MainActor.run {
                self.tasks.append(newTask)
            }
        }
    }
}
