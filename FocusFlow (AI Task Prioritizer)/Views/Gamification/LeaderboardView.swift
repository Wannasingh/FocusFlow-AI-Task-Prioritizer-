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
                .glassBackground(cornerRadius: 20)
            
            // Period Selector
            periodSelector
                .glassBackground(cornerRadius: 20)
            
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
        .background(
            LinearGradient(colors: [Color.black.opacity(0.92), Color.indigo.opacity(0.6), Color.purple.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
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
        HStack(spacing: 10) {
            ForEach(LeaderboardPeriod.allCases, id: \.self) { period in
                Button(action: { selectedPeriod = period }) {
                    Text(period.rawValue)
                        .font(.system(size: 13, weight: selectedPeriod == period ? .semibold : .medium))
                        .foregroundColor(selectedPeriod == period ? .white : (colorScheme == .dark ? .white : .black))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background {
                            if selectedPeriod == period {
                                RoundedRectangle(cornerRadius: 10).fill(Color.neoYellow)
                            } else {
                                RoundedRectangle(cornerRadius: 10).fill(.ultraThinMaterial)
                            }
                        }
                        .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(.white.opacity(0.25), lineWidth: 1))
                }
                .buttonStyle(PlainButtonStyle())
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
            Text(user.avatar)
                .font(.system(size: 28))
                .frame(width: 52, height: 52)
                .background(.ultraThinMaterial, in: Circle())
                .overlay(Circle().strokeBorder(Color.white.opacity(0.25), lineWidth: 1))
            Text(user.name)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .lineLimit(1)
            Text("\(user.score)")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(colorScheme == .dark ? .white : .black)
            Text("#\(user.rank)")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(color)
                .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .padding(.vertical, 12)
        .glassBackground(cornerRadius: 16)
    }
    
    // MARK: - Leaderboard Row
    private func leaderboardRow(_ user: LeaderboardUser) -> some View {
        HStack(spacing: 14) {
            Text("#\(user.rank)")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(user.isCurrentUser ? .neoCyan : (colorScheme == .dark ? .white : .black))
                .frame(width: 36, alignment: .leading)
            Text(user.avatar)
                .font(.system(size: 22))
                .frame(width: 40, height: 40)
                .background(.ultraThinMaterial, in: Circle())
                .overlay(Circle().strokeBorder(Color.white.opacity(0.25), lineWidth: 1))
            Text(user.name)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(user.isCurrentUser ? .neoCyan : (colorScheme == .dark ? .white : .black))
            Spacer()
            Text("\(user.score)")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(user.isCurrentUser ? .neoCyan : (colorScheme == .dark ? .white : .black))
        }
        .padding(14)
        .glassBackground(cornerRadius: 14)
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
