//
//  BottomNavBar.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import SwiftUI

enum NavTab: String, CaseIterable {
    case home = "Home"
    case tasks = "Tasks"
    case focus = "Focus"
    case profile = "Profile"
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .tasks: return "list.bullet.rectangle.fill"
        case .focus: return "stopwatch.fill"
        case .profile: return "person.fill"
        }
    }
    
    var highlightColor: Color {
        switch self {
        case .home: return .neoCyan
        case .tasks: return .neoYellow
        case .focus: return .neoPink
        case .profile: return .neoPurple
        }
    }
}

struct BottomNavBar: View {
    /// Fixed height so the bar is the same size and position on every tab. Use for content padding in MainTabView.
    static let barHeight: CGFloat = 64

    @Binding var selectedTab: NavTab
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(NavTab.allCases, id: \.self) { tab in
                tabButton(for: tab)
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 8)
        .padding(.bottom, 20)
        .frame(height: Self.barHeight)
        .background(.ultraThinMaterial)
        .overlay(
            RoundedRectangle(cornerRadius: 0)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        )
        .overlay(alignment: .top) {
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.white.opacity(0.2))
        }
    }
    
    @ViewBuilder
    private func tabButton(for tab: NavTab) -> some View {
        let isSelected = selectedTab == tab
        
        Button(action: {
            withAnimation(.easeOut(duration: 0.2)) { selectedTab = tab }
        }) {
            VStack(spacing: 6) {
                Image(systemName: tab.icon)
                    .font(.system(size: 20, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? tab.highlightColor : (colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.4)))
                Text(tab.rawValue)
                    .font(.system(size: 10, weight: isSelected ? .medium : .regular))
                    .foregroundColor(isSelected ? (colorScheme == .dark ? .white : .black) : .textSecondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .background(
                isSelected ?
                RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.08)) :
                nil
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color.white.opacity(0.18), lineWidth: isSelected ? 1 : 0)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack {
        Spacer()
        BottomNavBar(selectedTab: .constant(.focus))
    }
    .background(Color.backgroundLight)
}
