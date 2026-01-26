//
//  SupabaseConfig.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import Foundation

enum SupabaseConfig {
    // Read from Info.plist (which gets values from Config.xcconfig)
    static var supabaseURL: String {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String, !url.isEmpty else {
            fatalError("""
                ❌ SUPABASE_URL not configured!
                
                Please check:
                1. Info.plist contains SUPABASE_URL key with value $(SUPABASE_URL)
                2. Config.xcconfig contains SUPABASE_URL = your_url
                3. Project Settings -> Info -> Configurations is set to 'Config'
                """)
        }
        return url
    }
    
    static var supabaseAnonKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String, !key.isEmpty else {
            fatalError("""
                ❌ SUPABASE_ANON_KEY not configured!
                
                Please check:
                1. Info.plist contains SUPABASE_ANON_KEY key with value $(SUPABASE_ANON_KEY)
                2. Config.xcconfig contains SUPABASE_ANON_KEY = your_key
                3. Project Settings -> Info -> Configurations is set to 'Config'
                """)
        }
        return key
    }
}

