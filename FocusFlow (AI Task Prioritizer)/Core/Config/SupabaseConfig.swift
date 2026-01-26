//
//  SupabaseConfig.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import Foundation

enum SupabaseConfig {
    // Read from environment variables (set by Config.xcconfig)
    static var supabaseURL: String {
        guard let url = ProcessInfo.processInfo.environment["SUPABASE_URL"], !url.isEmpty else {
            fatalError("""
                ❌ SUPABASE_URL not configured!
                
                Please set up Config.xcconfig:
                1. Make sure Config.xcconfig exists in project root
                2. Add: SUPABASE_URL = your_supabase_url
                3. In Xcode: Project Settings → Info → Configurations → Set to 'Config'
                """)
        }
        return url
    }
    
    static var supabaseAnonKey: String {
        guard let key = ProcessInfo.processInfo.environment["SUPABASE_ANON_KEY"], !key.isEmpty else {
            fatalError("""
                ❌ SUPABASE_ANON_KEY not configured!
                
                Please set up Config.xcconfig:
                1. Make sure Config.xcconfig exists in project root
                2. Add: SUPABASE_ANON_KEY = your_supabase_key
                3. In Xcode: Project Settings → Info → Configurations → Set to 'Config'
                """)
        }
        return key
    }
}
