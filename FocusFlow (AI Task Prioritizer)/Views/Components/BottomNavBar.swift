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
    @Binding var selectedTab: NavTab
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            // Top border
            Rectangle()
                .frame(height: 4)
                .foregroundColor(.black)
            
            HStack(spacing: 0) {
                ForEach(NavTab.allCases, id: \.self) { tab in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = tab
                        }
                    }) {
                        VStack(spacing: 8) {
                            tabIconView(tab: tab)
                            
                            Text(tab.rawValue)
                                .font(.system(size: 14, weight: .black, design: .rounded))
                                .foregroundColor(.black)
                                .textCase(.uppercase)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 24) // Extra padding for home indicator
            .background(Color.white)
        }
    }
    
    @ViewBuilder
    private func tabIconView(tab: NavTab) -> some View {
        let isSelected = selectedTab == tab
        
        ZStack {
            if isSelected {
                // Background shadow for neubrutalism
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.black)
                    .offset(x: 4, y: 4)
                
                // Active Tab Background
                RoundedRectangle(cornerRadius: 15)
                    .fill(tab.highlightColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black, lineWidth: 3)
                    )
            }
            
            Image(systemName: tab.icon)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.black)
        }
        .frame(width: 70, height: 70)
    }
}

#Preview {
    VStack {
        Spacer()
        BottomNavBar(selectedTab: .constant(.home))
    }
    .background(Color.backgroundLight)
}
