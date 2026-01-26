//
//  LeaderboardView.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import SwiftUI

struct LeaderboardView: View {
    @State private var selectedPeriod: LeaderboardPeriod = .weekly
    @Environment(\.colorScheme) var colorScheme
    
    // Mock leaderboard data
    @State private var users: [LeaderboardUser] = [
        LeaderboardUser(rank: 1, name: "Alex Chen", score: 2847, avatar: "👑"),
        LeaderboardUser(rank: 2, name: "Sarah Kim", score: 2654, avatar: "🔥"),
        LeaderboardUser(rank: 3, name: "Mike Johnson", score: 2431, avatar: "⭐"),
        LeaderboardUser(rank: 4, name: "Emma Davis", score: 2198, avatar: "💎"),
        LeaderboardUser(rank: 5, name: "You", score: 2087, avatar: "🎯", isCurrentUser: true),
        LeaderboardUser(rank: 6, name: "John Smith", score: 1956, avatar: "🚀"),
        LeaderboardUser(rank: 7, name: "Lisa Wang", score: 1834, avatar: "✨")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            header
            
            // Period Selector
            periodSelector
            
            // Top 3 Podium
            topThree
            
            // Leaderboard List
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(users.dropFirst(3)) { user in
                        leaderboardRow(user)
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
            }
            .background(colorScheme == .dark ? Color.backgroundDarkDeep : Color.backgroundLight)
        }
        .background(colorScheme == .dark ? Color.backgroundDarkAlt : Color.backgroundLight)
    }
    
    // MARK: - Header
    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("LEADERBOARD")
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
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 12)
    }
    
    // MARK: - Period Selector
    private var periodSelector: some View {
        HStack(spacing: 12) {
            ForEach(LeaderboardPeriod.allCases, id: \.self) { period in
                Button(action: { selectedPeriod = period }) {
                    Text(period.rawValue)
                        .font(.displayBold(12))
                        .foregroundColor(.black)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selectedPeriod == period ? Color.neoYellow : Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 2)
                        )
                        .shadow(color: .black, radius: 0, x: selectedPeriod == period ? 0 : 2, y: selectedPeriod == period ? 0 : 2)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 20)
    }
    
    // MARK: - Top 3 Podium
    private var topThree: some View {
        HStack(alignment: .bottom, spacing: 16) {
            // 2nd Place
            podiumCard(users[1], height: 120, color: .neoCyan)
            
            // 1st Place
            podiumCard(users[0], height: 160, color: .neoYellow)
            
            // 3rd Place
            podiumCard(users[2], height: 100, color: .neoMagenta)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
    }
    
    private func podiumCard(_ user: LeaderboardUser, height: CGFloat, color: Color) -> some View {
        VStack(spacing: 8) {
            // Avatar
            Text(user.avatar)
                .font(.system(size: 32))
                .frame(width: 56, height: 56)
                .background(Color.white)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.black, lineWidth: 3))
                .shadow(color: .black, radius: 0, x: 2, y: 2)
            
            // Name
            Text(user.name)
                .font(.displayBold(12))
                .foregroundColor(.black)
                .lineLimit(1)
            
            // Score
            Text("\(user.score)")
                .font(.system(size: 20, weight: .black, design: .rounded))
                .foregroundColor(.black)
            
            // Rank Badge
            Text("#\(user.rank)")
                .font(.displayBold(14))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(Color.black)
                .cornerRadius(12)
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .padding(.vertical, 12)
        .background(color)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black, lineWidth: 3)
        )
        .shadow(color: .black, radius: 0, x: 4, y: 4)
    }
    
    // MARK: - Leaderboard Row
    private func leaderboardRow(_ user: LeaderboardUser) -> some View {
        HStack(spacing: 16) {
            // Rank
            Text("#\(user.rank)")
                .font(.displayBold(16))
                .foregroundColor(user.isCurrentUser ? .primaryGreen : (colorScheme == .dark ? .white : .black))
                .frame(width: 40, alignment: .leading)
            
            // Avatar
            Text(user.avatar)
                .font(.system(size: 24))
                .frame(width: 40, height: 40)
                .background(Color.white)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.black, lineWidth: 2))
            
            // Name
            Text(user.name)
                .font(.bodyBold(16))
                .foregroundColor(user.isCurrentUser ? .primaryGreen : (colorScheme == .dark ? .white : .black))
            
            Spacer()
            
            // Score
            Text("\(user.score)")
                .font(.displayBold(18))
                .foregroundColor(user.isCurrentUser ? .primaryGreen : (colorScheme == .dark ? .white : .black))
        }
        .padding(16)
        .background(user.isCurrentUser ? Color.primaryGreen.opacity(0.2) : (colorScheme == .dark ? Color.backgroundDarkDeep : Color.white))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(user.isCurrentUser ? Color.primaryGreen : (colorScheme == .dark ? Color.white : Color.black), lineWidth: user.isCurrentUser ? 3 : 2)
        )
        .shadow(color: user.isCurrentUser ? .primaryGreen : .black, radius: 0, x: user.isCurrentUser ? 4 : 2, y: user.isCurrentUser ? 4 : 2)
    }
}

// MARK: - Supporting Types
enum LeaderboardPeriod: String, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
}

struct LeaderboardUser: Identifiable {
    let id = UUID()
    let rank: Int
    let name: String
    let score: Int
    let avatar: String
    var isCurrentUser: Bool = false
}

#Preview {
    LeaderboardView()
}
