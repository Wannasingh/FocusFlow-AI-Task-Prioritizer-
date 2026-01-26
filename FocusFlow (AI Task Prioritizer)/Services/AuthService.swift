//
//  AuthService.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 27/1/2569 BE.
//

import Foundation
import SwiftUI
import Combine
import Supabase
import AuthenticationServices

@MainActor
class AuthService: ObservableObject {
    @Published var currentUser: Models.User?
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
            isAuthenticated = true
            await fetchUserProfile(userId: session.user.id)
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
            try await createUserProfile(
                userId: response.user.id,
                email: email,
                displayName: displayName
            )
            
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
            
            await fetchUserProfile(userId: response.user.id)
            
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
            // Get OAuth URL from Supabase (Synchronous in some v2 versions)
            let url = try supabase.auth.getOAuthSignInURL(
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
            // Get OAuth URL from Supabase (Synchronous in some v2 versions)
            let url = try supabase.auth.getOAuthSignInURL(
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
    
    private func createUserProfile(userId: UUID, email: String, displayName: String) async throws {
        let newUser = Models.User(
            id: userId,
            email: email,
            displayName: displayName,
            avatarURL: nil,
            focusScore: 0,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        try await supabase
            .from("users")
            .insert(newUser)
            .execute()
        
        currentUser = newUser
    }
    
    private func fetchUserProfile(userId: UUID) async {
        do {
            let users: [Models.User] = try await supabase
                .from("users")
                .select()
                .eq("id", value: userId.uuidString)
                .execute()
                .value
            
            currentUser = users.first
        } catch {
            print("❌ Error fetching user profile: \(error)")
        }
    }
    
    private func openOAuthURL(_ url: URL) async {
        // We use ASWebAuthenticationSession for a better experience 
        // It opens an in-app browser or the default browser and handles the callback for us
        // Note: For iOS, it's a better UX. For macOS, it handles the sandbox more strictly.
        
        let session = ASWebAuthenticationSession(
            url: url,
            callbackURLScheme: "focusflow"
        ) { callbackURL, error in
            if let error = error {
                print("❌ OAuth Error: \(error.localizedDescription)")
                return
            }
            
            if let callbackURL = callbackURL {
                Task {
                    try? await self.handleOAuthCallback(url: callbackURL)
                }
            }
        }
        
        #if os(iOS)
        session.presentationContextProvider = AuthPresentationContextHandler.shared
        #endif
        
        session.start()
    }
    
    // MARK: - Handle OAuth Callback
    func handleOAuthCallback(url: URL) async throws {
        do {
            // 1. Ingest the session from URL
            let session = try await supabase.auth.session(from: url)
            
            // 2. Fetch or Create profile based on the session user
            try await syncUserProfile(sessionUser: session.user)
            
            // 3. Update UI state
            isAuthenticated = true
        } catch {
            print("❌ Error handling OAuth callback: \(error.localizedDescription)")
            errorMessage = "Authentication failed: \(error.localizedDescription)"
            throw error
        }
    }
    
    private func syncUserProfile(sessionUser: User) async throws {
        do {
            // 1. Create the user object from session data
            let newUser = Models.User(
                id: sessionUser.id,
                email: sessionUser.email ?? "",
                displayName: sessionUser.userMetadata["full_name"]?.value as? String ?? 
                             sessionUser.userMetadata["name"]?.value as? String ?? "Google User",
                avatarURL: sessionUser.userMetadata["avatar_url"]?.value as? String,
                focusScore: 0,
                createdAt: Date(),
                updatedAt: Date()
            )
            
            // 2. Try to UPSERT (Update or Insert) the profile
            // This is safer than a simple insert as it won't fail if the user already exists
            print("📝 Syncing user profile for: \(newUser.email)")
            
            try await supabase
                .from("users")
                .upsert(newUser)
                .execute()
            
            self.currentUser = newUser
        } catch {
            print("❌ Error syncing user profile: \(error)")
            
            // If it's a "Database error", let's try to fetch what's already there 
            // maybe the trigger created it for us!
            do {
                let existing: [Models.User] = try await supabase
                    .from("users")
                    .select()
                    .eq("id", value: sessionUser.id.uuidString)
                    .execute()
                    .value
                
                if let profile = existing.first {
                    print("✅ Found existing profile, proceeding...")
                    self.currentUser = profile
                } else {
                    // If still missing and erroring, throw the original error
                    throw error
                }
            } catch {
                print("❌ Final profile sync failure: \(error)")
                throw error
            }
        }
    }


}


// Helper to provide the window for ASWebAuthenticationSession
class AuthPresentationContextHandler: NSObject, ASWebAuthenticationPresentationContextProviding {
    static let shared = AuthPresentationContextHandler()
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        #if os(iOS)
        // Accessing the window in iOS
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return scene?.windows.first { $0.isKeyWindow } ?? ASPresentationAnchor()
        #else
        // Accessing the window in macOS
        return NSApplication.shared.windows.first { $0.isKeyWindow } ?? ASPresentationAnchor()
        #endif
    }
}


