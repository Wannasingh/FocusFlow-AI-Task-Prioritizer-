//
//  UserProfileView.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import SwiftUI

struct UserProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var userName = "Alex Chen"
    @State private var userEmail = "alex.chen@example.com"
    
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
    }
    
    // MARK: - Profile Header
    private var profileHeader: some View {
        VStack(spacing: 16) {
            // Avatar
            Circle()
                .fill(Color.neoYellow)
                .frame(width: 120, height: 120)
                .overlay(
                    Text("AC")
                        .font(.system(size: 48, weight: .black, design: .rounded))
                        .foregroundColor(.black)
                )
                .overlay(Circle().stroke(Color.black, lineWidth: 4))
                .shadow(color: .black, radius: 0, x: 6, y: 6)
            
            // Name
            Text(userName)
                .font(.system(size: 28, weight: .black, design: .rounded))
                .foregroundColor(colorScheme == .dark ? .white : .black)
            
            // Email
            Text(userEmail)
                .font(.bodyMedium(16))
                .foregroundColor(.textSecondary)
            
            // Edit Profile Button
            Button(action: {}) {
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
    
    // MARK: - Stats Section
    private var statsSection: some View {
        VStack(spacing: 16) {
            Text("YOUR STATS")
                .font(.displayBold(14))
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 16) {
                statCard(value: "84", label: "Focus Score", color: .neoYellow)
                statCard(value: "127", label: "Tasks Done", color: .neoCyan)
            }
            
            HStack(spacing: 16) {
                statCard(value: "42h", label: "Focus Time", color: .neoMagenta)
                statCard(value: "#5", label: "Rank", color: .neoLime)
            }
        }
    }
    
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
    
    // MARK: - Recent Activity
    private var recentActivity: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("RECENT ACTIVITY")
                .font(.displayBold(14))
                .foregroundColor(colorScheme == .dark ? .white : .black)
            
            VStack(spacing: 12) {
                activityRow(icon: "checkmark.circle.fill", text: "Completed 'Design System Update'", time: "2h ago", color: .primaryGreen)
                activityRow(icon: "trophy.fill", text: "Unlocked 'Week Warrior' achievement", time: "1d ago", color: .neoOrange)
                activityRow(icon: "target", text: "Reached goal: 50 Tasks", time: "3d ago", color: .neoCyan)
            }
        }
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
}
