//
//  UserProfileView.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import SwiftUI

struct UserProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authService: AuthService
    @State private var showEditProfile = false
    
    /// ข้อมูลจาก DB ผ่าน AuthService (ตาราง users)
    private var user: Models.User? { authService.currentUser }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                profileHeader
                    .glassBackground(cornerRadius: 20)
                actionsRow
                    .glassBackground(cornerRadius: 16)
                statsSection
                settingsRow
                    .glassBackground(cornerRadius: 16)
                Spacer(minLength: 32)
            }
            .padding(.horizontal, 20)
        }
        .background(
            LinearGradient(colors: [Color.black.opacity(0.92), Color.indigo.opacity(0.6), Color.purple.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .sheet(isPresented: $showEditProfile) {
            EditProfileView()
                .environmentObject(authService)
        }
    }
    
    // MARK: - Profile Header (minimal)
    private var profileHeader: some View {
        VStack(spacing: 12) {
            Group {
                if let urlString = user?.avatarURL, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image): image.resizable().scaledToFill()
                        case .failure(_), .empty: avatarInitialsView
                        @unknown default: avatarInitialsView
                        }
                    }
                    .frame(width: 88, height: 88)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                } else {
                    avatarInitialsView
                        .frame(width: 88, height: 88)
                }
            }
            .frame(width: 88, height: 88)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(colorScheme == .dark ? Color.white.opacity(0.3) : Color.black.opacity(0.15), lineWidth: 1))
            
            Text(user?.displayName ?? "User")
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
            Text(user?.email ?? "")
                .font(.footnote)
                .foregroundStyle(.white.opacity(0.8))
        }
        .padding(.top, 20)
    }
    
    private var actionsRow: some View {
        HStack(spacing: 12) {
            Button(action: { showEditProfile = true }) {
                Text("Edit profile")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .glassBar(cornerRadius: 12)
            }
            .buttonStyle(PlainButtonStyle())

            Button(action: { Task { try? await authService.signOut() } }) {
                Text("Logout")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.red.opacity(0.85))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(.white.opacity(0.2), lineWidth: 1))
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private var avatarInitialsView: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.neoYellow.opacity(0.9))
            .overlay(
                Text(avatarInitials)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.black.opacity(0.8))
            )
    }
    
    /// Initial สำหรับ avatar (2 ตัวอักษรจาก display_name)
    private var avatarInitials: String {
        let name = user?.displayName ?? ""
        let parts = name.split(separator: " ").map(String.init)
        if parts.count >= 2, let f = parts.first?.first, let s = parts.last?.first {
            return "\(f)\(s)".uppercased()
        }
        let prefix = String(name.prefix(2)).uppercased()
        return prefix.isEmpty ? "?" : prefix
    }
    
    // MARK: - Stats (minimal row)
    private var statsSection: some View {
        HStack(spacing: 0) {
            statItem(value: "\(user?.focusScore ?? 0)", label: "Focus")
            Divider().frame(height: 32).background(colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.1))
            statItem(value: "0", label: "Tasks")
            Divider().frame(height: 32).background(colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.1))
            statItem(value: "—", label: "Rank")
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .glassSubtle(cornerRadius: 12)
    }

    private func statItem(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(colorScheme == .dark ? .white : .black)
            Text(label)
                .font(.caption2.weight(.medium))
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var settingsRow: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: "gearshape")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.textSecondary)
                Text("Settings")
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.textSecondary)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    UserProfileView()
        .environmentObject(AuthService())
}
