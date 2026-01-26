//
//  AIConfig.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by Antigravity on 27/1/2569 BE.
//

import Foundation

enum AIConfig {
    static var geminiAPIKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "GEMINI_API_KEY") as? String, !key.isEmpty else {
            // We don't want to crash here if the user hasn't set it yet, 
            // but we should provide a way to check if it's available.
            return ""
        }
        return key
    }
    
    static var isGeminiConfigured: Bool {
        let key = geminiAPIKey
        return !key.isEmpty && key != "YOUR_GEMINI_API_KEY_HERE"
    }
}
