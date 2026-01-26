//
//  SupabaseConfig.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import Foundation

enum SupabaseConfig {
    // Read from environment variables (set by Config.xcconfig)
    // Fallback to hardcoded values for development (you can remove these later)
    static var supabaseURL: String {
        // Try environment variable first
        if let envURL = ProcessInfo.processInfo.environment["SUPABASE_URL"], !envURL.isEmpty {
            return envURL
        }
        // Fallback for development
        return "***REMOVED***"
    }
    
    static var supabaseAnonKey: String {
        // Try environment variable first
        if let envKey = ProcessInfo.processInfo.environment["SUPABASE_ANON_KEY"], !envKey.isEmpty {
            return envKey
        }
        // Fallback for development
        return "***REMOVED***"
    }
}

