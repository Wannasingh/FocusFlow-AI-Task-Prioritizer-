//
//  TrophyRoomView.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import SwiftUI

struct TrophyRoomView: View {
    @Environment(\.colorScheme) var colorScheme
    
    // Mock achievements
    @State private var achievements: [AchievementItem] = [
        AchievementItem(title: "First Task", icon: "🎯", description: "Complete your first task", isUnlocked: true, color: .neoYellow),
        AchievementItem(title: "Week Warrior", icon: "🔥", description: "7 day streak", isUnlocked: true, color: .neoOrange),
        AchievementItem(title: "Focus Master", icon: "⚡", description: "100 focus sessions", isUnlocked: true, color: .neoCyan),
        AchievementItem(title: "Goal Crusher", icon: "🎖️", description: "Complete 10 goals", isUnlocked: false, color: .neoMagenta),
        AchievementItem(title: "Productivity King", icon: "👑", description: "Reach #1 on leaderboard", isUnlocked: false, color: .neoYellow),
        AchievementItem(title: "Marathon Runner", icon: "🏃", description: "30 day streak", isUnlocked: false, color: .neoPurple)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                header
                
                // Stats
                statsSection
                
                // Achievements Grid
                achievementsGrid
                
                Spacer(minLength: 40)
            }
            .padding(.horizontal, 24)
        }
        .background(
            LinearGradient(colors: [Color.black.opacity(0.92), Color.indigo.opacity(0.6), Color.purple.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
    }
    
    // MARK: - Header
    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("TROPHY ROOM")
                .font(.system(size: 36, weight: .black, design: .rounded))
                .foregroundColor(colorScheme == .dark ? .white : .black)
            
            Rectangle()
                .fill(Color.neoYellow)
                .frame(width: 100, height: 6)
                .overlay(
                    Rectangle()
                        .stroke(Color.black, lineWidth: 2)
                )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 16)
    }
    
    // MARK: - Stats Section
    private var statsSection: some View {
        HStack(spacing: 16) {
            statCard(value: "\(achievements.filter { $0.isUnlocked }.count)", label: "Unlocked", color: .neoYellow)
            statCard(value: "\(achievements.count)", label: "Total", color: .neoCyan)
        }
    }
    
    private func statCard(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(colorScheme == .dark ? .white : .black)
            Text(label)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .glassBackground(cornerRadius: 16)
    }
    
    // MARK: - Achievements Grid
    private var achievementsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            ForEach(achievements) { achievement in
                achievementCard(achievement)
            }
        }
    }
    
    private func achievementCard(_ achievement: AchievementItem) -> some View {
        VStack(spacing: 12) {
            Text(achievement.icon)
                .font(.system(size: 40))
                .opacity(achievement.isUnlocked ? 1.0 : 0.4)
                .frame(width: 64, height: 64)
                .background(.ultraThinMaterial, in: Circle())
                .overlay(Circle().strokeBorder(.white.opacity(0.3), lineWidth: 1))
            Text(achievement.title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            Text(achievement.description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            if !achievement.isUnlocked {
                HStack(spacing: 4) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 9, weight: .semibold))
                    Text("Locked")
                        .font(.system(size: 9, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.gray)
                .clipShape(Capsule())
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .glassBackground(cornerRadius: 16)
        .opacity(achievement.isUnlocked ? 1.0 : 0.85)
    }
}

// MARK: - Supporting Types
struct AchievementItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let description: String
    var isUnlocked: Bool
    let color: Color
}

#Preview {
    TrophyRoomView()
}
