//
//  SupabaseClient.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import Foundation
import Supabase

class SupabaseClient {
    static let shared = SupabaseClient()
    
    let client: SupabaseClient
    
    private init() {
        self.client = SupabaseClient(
            supabaseURL: URL(string: SupabaseConfig.supabaseURL)!,
            supabaseKey: SupabaseConfig.supabaseAnonKey
        )
    }
    
    // Test connection
    func testConnection() async throws -> Bool {
        // Try to fetch from a simple query
        let response = try await client
            .from("users")
            .select()
            .limit(1)
            .execute()
        
        return response.status == 200
    }
}
