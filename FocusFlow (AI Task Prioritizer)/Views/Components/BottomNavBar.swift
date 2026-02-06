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
        VStack(spacing: 0) {
            Rectangle()
                .frame(height: 2)
                .foregroundColor(.black)
            
            HStack(alignment: .top, spacing: 0) {
                ForEach(NavTab.allCases, id: \.self) { tab in
                    tabButton(for: tab)
                }
            }
            .padding(.horizontal, 8)
            .frame(height: Self.barHeight - 2)
            .background(Color.white)
        }
        .frame(height: Self.barHeight)
    }
    
    /// ทุก tab ความสูงเท่ากัน + จัดแนวบน เพื่อไม่ให้ tab ใดเลื่อนลง
    @ViewBuilder
    private func tabButton(for tab: NavTab) -> some View {
        let isSelected = selectedTab == tab
        
        Button(action: {
            withAnimation(.easeOut(duration: 0.2)) {
                selectedTab = tab
            }
        }) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(tab.highlightColor)
                            .frame(width: 40, height: 40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
                    Image(systemName: tab.icon)
                        .font(.system(size: isSelected ? 20 : 18, weight: .bold))
                        .foregroundColor(isSelected ? .black : .black.opacity(0.6))
                }
                .frame(width: 40, height: 40)
                
                Text(tab.rawValue.uppercased())
                    .font(.system(size: 9, weight: .black, design: .rounded))
                    .foregroundColor(isSelected ? .black : .black.opacity(0.6))
                    .lineLimit(1)
                    .frame(height: 14)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .contentShape(Rectangle())
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
