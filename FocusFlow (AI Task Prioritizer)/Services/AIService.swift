//
//  AIService.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by Antigravity on 27/1/2569 BE.
//

import Foundation
import Supabase
import GoogleGenerativeAI
import Combine

class AIService {
    static let shared = AIService()
    
    private var model: GenerativeModel?
    
    private init() {
        let apiKey = AIConfig.geminiAPIKey
        if !apiKey.isEmpty && apiKey != "YOUR_GEMINI_API_KEY_HERE" {
            self.model = GenerativeModel(name: "gemini-1.5-flash", apiKey: apiKey)
        }
    }
    
    func analyzeTaskPriority(
        title: String,
        description: String?,
        category: String,
        dueDate: Date?
    ) async throws -> Double {
        guard let model = model else {
            throw AIError.notConfigured
        }
        
        let dateString = dueDate != nil ? ISO8601DateFormatter().string(from: dueDate!) : "No due date"
        
        let prompt = """
        Analyze the following task and provide a priority score between 0.0 and 1.0, where 1.0 is the highest priority.
        Consider the title, description, category, and due date.
        Return ONLY the numerical score as a double.
        
        Task Title: \(title)
        Task Description: \(description ?? "No description")
        Category: \(category)
        Due Date: \(dateString)
        Current Date: \(ISO8601DateFormatter().string(from: Date()))
        
        Priority Score:
        """
        
        let response = try await model.generateContent(prompt)
        
        if let text = response.text, let score = Double(text.trimmingCharacters(in: .whitespacesAndNewlines)) {
            return min(max(score, 0.0), 1.0)
        } else {
            throw AIError.invalidResponse
        }
    }
    
    enum AIError: Error {
        case notConfigured
        case invalidResponse
    }
}
