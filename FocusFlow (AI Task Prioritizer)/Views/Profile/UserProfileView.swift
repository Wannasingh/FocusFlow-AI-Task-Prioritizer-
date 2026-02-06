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
            VStack(spacing: 24) {
                // Profile Header
                profileHeader
                
                // Stats Cards
                statsSection
                
                // Recent Activity
                recentActivity
                
                // Settings Button
                settingsButton
                
                Spacer(minLength: 40)
            }
            .padding(.horizontal, 24)
        }
        .background(colorScheme == .dark ? Color.backgroundDarkAlt : Color.backgroundLight)
        .sheet(isPresented: $showEditProfile) {
            EditProfileView()
                .environmentObject(authService)
        }
    }
    
    // MARK: - Profile Header (จาก DB: users ผ่าน authService.currentUser)
    private var profileHeader: some View {
        VStack(spacing: 16) {
            // Avatar – จาก Supabase Storage (avatar_url) หรือ initial จาก display_name
            Group {
                if let urlString = user?.avatarURL, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable().scaledToFill()
                        case .failure(_), .empty:
                            avatarInitialsView
                        @unknown default:
                            avatarInitialsView
                        }
                    }
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                } else {
                    avatarInitialsView
                }
            }
            .frame(width: 120, height: 120)
            .overlay(Circle().stroke(Color.black, lineWidth: 4))
            .shadow(color: .black, radius: 0, x: 6, y: 6)
            
            // Name (จาก DB: display_name)
            Text(user?.displayName ?? "User")
                .font(.system(size: 28, weight: .black, design: .rounded))
                .foregroundColor(colorScheme == .dark ? .white : .black)
            
            // Email (จาก DB: email)
            Text(user?.email ?? "")
                .font(.bodyMedium(16))
                .foregroundColor(.textSecondary)
            
            // Edit Profile Button
            Button(action: { showEditProfile = true }) {
                Text("EDIT PROFILE")
                    .font(.displayBold(14))
                    .foregroundColor(.black)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black, lineWidth: 2)
                    )
                    .shadow(color: .black, radius: 0, x: 3, y: 3)
            }
        }
        .padding(.top, 24)
    }
    
    private var avatarInitialsView: some View {
        Circle()
            .fill(Color.neoYellow)
            .overlay(
                Text(avatarInitials)
                    .font(.system(size: 48, weight: .black, design: .rounded))
                    .foregroundColor(.black)
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
    
    // MARK: - Stats Section (focusScore จาก DB, อื่นๆ ยัง placeholder จนมีตาราง/API)
    private var statsSection: some View {
        VStack(spacing: 16) {
            Text("YOUR STATS")
                .font(.displayBold(14))
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 16) {
                statCard(value: "\(user?.focusScore ?? 0)", label: "Focus Score", color: .neoYellow)
                statCard(value: tasksDoneText, label: "Tasks Done", color: .neoCyan)
            }
            
            HStack(spacing: 16) {
                statCard(value: focusTimeText, label: "Focus Time", color: .neoMagenta)
                statCard(value: rankText, label: "Rank", color: .neoLime)
            }
        }
    }
    
    /// Placeholder จนกว่าจะมีตาราง/API สำหรับ tasks done
    private var tasksDoneText: String { "0" }
    /// Placeholder จนกว่าจะมีตาราง/API สำหรับ focus time
    private var focusTimeText: String { "0h" }
    /// Placeholder จนกว่าจะมีตาราง/API สำหรับ rank
    private var rankText: String { "—" }
    
    private func statCard(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.system(size: 28, weight: .black, design: .rounded))
                .foregroundColor(.black)
            
            Text(label)
                .font(.displayBold(11))
                .foregroundColor(.black)
                .textCase(.uppercase)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(color)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black, lineWidth: 3)
        )
        .shadow(color: .black, radius: 0, x: 3, y: 3)
    }
    
    // MARK: - Recent Activity (placeholder จนกว่าจะมีตาราง activity)
    private var recentActivity: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("RECENT ACTIVITY")
                .font(.displayBold(14))
                .foregroundColor(colorScheme == .dark ? .white : .black)
            
            if recentActivities.isEmpty {
                Text("No recent activity")
                    .font(.bodyMedium(14))
                    .foregroundColor(.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
            } else {
                VStack(spacing: 12) {
                    ForEach(recentActivities, id: \.text) { item in
                        activityRow(icon: item.icon, text: item.text, time: item.time, color: item.color)
                    }
                }
            }
        }
    }
    
    /// ข้อมูล activity – ตอนนี้ว่าง, ต่อไปดึงจาก DB/API
    private var recentActivities: [(icon: String, text: String, time: String, color: Color)] {
        [] // TODO: fetch จากตาราง activity / events
    }
    
    private func activityRow(icon: String, text: String, time: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.2))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 2)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(text)
                    .font(.bodyMedium(14))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
                Text(time)
                    .font(.mono(12))
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
        }
        .padding(12)
        .background(colorScheme == .dark ? Color.backgroundDarkDeep : Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 2)
        )
    }
    
    // MARK: - Settings Button
    private var settingsButton: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 20, weight: .bold))
                
                Text("SETTINGS")
                    .font(.displayBold(16))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .bold))
            }
            .foregroundColor(.black)
            .padding(20)
            .background(Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.black, lineWidth: 3)
            )
            .shadow(color: .black, radius: 0, x: 4, y: 4)
        }
    }
}

#Preview {
    UserProfileView()
        .environmentObject(AuthService())
}
