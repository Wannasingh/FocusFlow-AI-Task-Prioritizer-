//
//  AuthService.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 27/1/2569 BE.
//

import Foundation
import Supabase
import AuthenticationServices

@MainActor
class AuthService: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let supabase = SupabaseManager.shared.client
    
    init() {
        Task {
            await checkAuthStatus()
        }
    }
    
    // MARK: - Check Auth Status
    func checkAuthStatus() async {
        do {
            let session = try await supabase.auth.session
            isAuthenticated = session.user != nil
            if let user = session.user {
                await fetchUserProfile(userId: user.id.uuidString)
            }
        } catch {
            isAuthenticated = false
            currentUser = nil
        }
    }
    
    // MARK: - Email Sign Up
    func signUp(email: String, password: String, displayName: String) async throws {
        isLoading = true
        errorMessage = nil
        
        do {
            // Sign up with Supabase Auth
            let response = try await supabase.auth.signUp(
                email: email,
                password: password
            )
            
            // Create user profile in database
            if let userId = response.user?.id.uuidString {
                try await createUserProfile(
                    userId: userId,
                    email: email,
                    displayName: displayName
                )
            }
            
            isAuthenticated = true
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            throw error
        }
    }
    
    // MARK: - Email Sign In
    func signIn(email: String, password: String) async throws {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await supabase.auth.signIn(
                email: email,
                password: password
            )
            
            if let userId = response.user?.id.uuidString {
                await fetchUserProfile(userId: userId)
            }
            
            isAuthenticated = true
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            throw error
        }
    }
    
    // MARK: - Sign In with Google
    func signInWithGoogle() async throws {
        isLoading = true
        errorMessage = nil
        
        do {
            // Get OAuth URL from Supabase
            let url = try await supabase.auth.getOAuthSignInURL(
                provider: .google,
                redirectTo: URL(string: "focusflow://auth/callback")
            )
            
            // Open OAuth flow
            await openOAuthURL(url)
            
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            throw error
        }
    }
    
    // MARK: - Sign In with Facebook
    func signInWithFacebook() async throws {
        isLoading = true
        errorMessage = nil
        
        do {
            // Get OAuth URL from Supabase
            let url = try await supabase.auth.getOAuthSignInURL(
                provider: .facebook,
                redirectTo: URL(string: "focusflow://auth/callback")
            )
            
            // Open OAuth flow
            await openOAuthURL(url)
            
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            throw error
        }
    }
    
    // MARK: - Sign Out
    func signOut() async throws {
        do {
            try await supabase.auth.signOut()
            isAuthenticated = false
            currentUser = nil
        } catch {
            errorMessage = error.localizedDescription
            throw error
        }
    }
    
    // MARK: - Reset Password
    func resetPassword(email: String) async throws {
        isLoading = true
        errorMessage = nil
        
        do {
            try await supabase.auth.resetPasswordForEmail(email)
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            throw error
        }
    }
    
    // MARK: - Private Helpers
    
    private func createUserProfile(userId: String, email: String, displayName: String) async throws {
        let newUser = User(
            id: userId,
            email: email,
            displayName: displayName,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        try await supabase
            .from("users")
            .insert(newUser)
            .execute()
        
        currentUser = newUser
    }
    
    private func fetchUserProfile(userId: String) async {
        do {
            let users: [User] = try await supabase
                .from("users")
                .select()
                .eq("id", value: userId)
                .execute()
                .value
            
            currentUser = users.first
        } catch {
            print("❌ Error fetching user profile: \(error)")
        }
    }
    
    private func openOAuthURL(_ url: URL) async {
        #if os(iOS)
        await UIApplication.shared.open(url)
        #endif
    }
    
    // MARK: - Handle OAuth Callback
    func handleOAuthCallback(url: URL) async throws {
        // Extract tokens from callback URL
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            throw NSError(domain: "AuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid callback URL"])
        }
        
        // Supabase will handle the session automatically
        await checkAuthStatus()
    }
}
