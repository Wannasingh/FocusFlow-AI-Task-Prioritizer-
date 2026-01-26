//
//  SupabaseClient.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init() {
        self.client = SupabaseClient(
            supabaseURL: URL(string: SupabaseConfig.supabaseURL)!,
            supabaseKey: SupabaseConfig.supabaseAnonKey,
            options: SupabaseClientOptions(
                auth: .init(
                    emitLocalSessionAsInitialSession: true
                )
            )
        )
    }
    
    // Test connection by checking if we can query the database
    func testConnection() async throws -> Bool {
        do {
            // Try to query the users table (just to test connection)
            let _: [Models.User] = try await client
                .from("users")
                .select()
                .limit(1)
                .execute()
                .value
            
            return true
        } catch {
            print("❌ Supabase connection error: \(error)")
            throw error
        }
    }
}

