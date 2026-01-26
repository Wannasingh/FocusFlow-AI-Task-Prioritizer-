//
//  SupabaseConfig.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import Foundation

enum SupabaseConfig {
    // These values are loaded from Info.plist which gets them from Config.xcconfig
    static var supabaseURL: String {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String else {
            fatalError("SUPABASE_URL not found in Info.plist. Please configure Config.xcconfig")
        }
        return url
    }
    
    static var supabaseAnonKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String else {
            fatalError("SUPABASE_ANON_KEY not found in Info.plist. Please configure Config.xcconfig")
        }
        return key
    }
}
