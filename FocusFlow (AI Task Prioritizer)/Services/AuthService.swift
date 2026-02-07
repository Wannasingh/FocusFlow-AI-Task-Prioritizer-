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
    
    // MARK: - Update Profile (ตาราง users) — ใช้ RPC เพื่อไม่ติด RLS
    func updateProfile(displayName: String, avatarURL: String?) async throws {
        guard let user = currentUser else { return }
        errorMessage = nil
        
        _ = try? await supabase.auth.refreshSession()
        
        let name = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        let url = avatarURL?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true ? nil : avatarURL
        
        let params: [String: String?] = ["p_display_name": name, "p_avatar_url": url]
        try await supabase.rpc("update_my_profile", params: params).execute()
        
        await fetchUserProfile(userId: user.id)
    }
    
    /// อัปโหลดรูปโปรไฟล์ไป Supabase Storage bucket "avatars" แล้วคืน public URL
    /// - Parameter imageData: ข้อมูลรูป JPEG
    /// - Returns: URL สาธารณะของรูป (ใช้เก็บใน users.avatar_url)
    func uploadAvatar(imageData: Data) async throws -> String {
        guard let user = currentUser else { throw NSError(domain: "AuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not logged in"]) }
        let path = "\(user.id.uuidString)/avatar.jpg"
        
        try await supabase.storage
            .from("avatars")
            .upload(
                path,
                data: imageData,
                options: FileOptions(
                    contentType: "image/jpeg",
                    upsert: true
                )
            )
        
        let publicURL = try supabase.storage
            .from("avatars")
            .getPublicURL(path: path)
        return publicURL.absoluteString
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
            // 2. Refresh เพื่อให้ได้ user_metadata เต็มจาก provider (รวม picture จาก Google)
            _ = try? await supabase.auth.refreshSession()
            let sessionUser = (try? await supabase.auth.session)?.user ?? session.user
            
            // 3. Fetch or Create profile based on the session user
            try await syncUserProfile(sessionUser: sessionUser)
            
            // 3. Update UI state
            isAuthenticated = true
        } catch {
            print("❌ Error handling OAuth callback: \(error.localizedDescription)")
            errorMessage = "Authentication failed: \(error.localizedDescription)"
            throw error
        }
    }
    
    /// ดึง URL รูปจาก user_metadata (Google ใช้ "picture", บาง provider ใช้ "avatar_url")
    private func avatarURLFromMetadata(_ sessionUser: User) -> String? {
        let keys = ["picture", "avatar_url", "avatar", "image_url"]
        for key in keys {
            if let s = sessionUser.userMetadata[key]?.value as? String, !s.isEmpty, s.hasPrefix("http") {
                return s
            }
        }
        return nil
    }
    
    private func syncUserProfile(sessionUser: User) async throws {
        do {
            // ชื่อจาก Google ใช้เฉพาะครั้งแรก (user ใหม่); ถ้ามีแถวใน DB แล้ว ใช้ display_name จาก DB เสมอ
            let googleName = sessionUser.userMetadata["full_name"]?.value as? String
                ?? sessionUser.userMetadata["name"]?.value as? String
                ?? "Google User"
            let googleAvatarURL = avatarURLFromMetadata(sessionUser)
            
            let existing: [Models.User]? = try? await supabase
                .from("users")
                .select()
                .eq("id", value: sessionUser.id.uuidString)
                .execute()
                .value
            
            let displayName: String
            let avatarURL: String?
            let createdAt: Date
            let updatedAt = Date()
            
            if let profile = existing?.first {
                // มีแถวใน DB แล้ว → ใช้ชื่อและรูปจาก DB (ไม่เขียนทับจาก Google)
                displayName = profile.displayName
                avatarURL = profile.avatarURL
                createdAt = profile.createdAt ?? updatedAt
            } else {
                // User ใหม่ → ใช้ชื่อจาก Google ครั้งแรก; รูปถ้ามีจาก metadata ก็ใช้
                displayName = googleName
                avatarURL = googleAvatarURL
                createdAt = updatedAt
            }
            
            let userToSave = Models.User(
                id: sessionUser.id,
                email: sessionUser.email ?? "",
                displayName: displayName,
                avatarURL: avatarURL,
                focusScore: existing?.first?.focusScore ?? 0,
                createdAt: createdAt,
                updatedAt: updatedAt
            )
            
            print("📝 Syncing user profile for: \(userToSave.email) (displayName: \(displayName))")
            
            try await supabase
                .from("users")
                .upsert(userToSave)
                .execute()
            
            self.currentUser = userToSave
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
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        if let window = scenes.lazy.flatMap(\.windows).first {
            return window
        }
        if let scene = scenes.first {
            return UIWindow(windowScene: scene)
        }
        fatalError("No window scene available for OAuth presentation")
        #else
        return NSApplication.shared.windows.first { $0.isKeyWindow } ?? NSApplication.shared.windows.first ?? NSWindow()
        #endif
    }
}


