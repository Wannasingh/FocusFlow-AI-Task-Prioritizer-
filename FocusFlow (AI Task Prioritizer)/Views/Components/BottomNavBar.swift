//
//  BottomNavBar.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import SwiftUI

enum NavTab: String, CaseIterable {
    case dashboard = "Dashboard"
    case tasks = "Tasks"
    case insights = "Insights"
    
    var icon: String {
        switch self {
        case .dashboard: return "square.grid.2x2.fill"
        case .tasks: return "checkmark.square.fill"
        case .insights: return "sparkles"
        }
    }
}

struct BottomNavBar: View {
    @Binding var selectedTab: NavTab
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(NavTab.allCases, id: \.self) { tab in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 24, weight: .bold))
                        
                        Text(tab.rawValue)
                            .font(.displayBold(10))
                            .textCase(.uppercase)
                    }
                    .foregroundColor(selectedTab == tab ? (colorScheme == .dark ? .primaryGreen : .black) : .gray)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(
                        selectedTab == tab ?
                        (colorScheme == .dark ? Color.black : Color.neoYellow) :
                        Color.clear
                    )
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                selectedTab == tab ? (colorScheme == .dark ? .white : .black) : .clear,
                                lineWidth: 2
                            )
                    )
                    .shadow(
                        color: selectedTab == tab ? (colorScheme == .dark ? .primaryGreen : .black) : .clear,
                        radius: 0,
                        x: selectedTab == tab ? 2 : 0,
                        y: selectedTab == tab ? 2 : 0
                    )
                    .offset(
                        x: 0,
                        y: selectedTab == tab ? -4 : 0
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 10)
        .background(
            (colorScheme == .dark ? Color.backgroundDarkAlt : Color.white)
                .overlay(
                    Rectangle()
                        .frame(height: 4)
                        .foregroundColor(colorScheme == .dark ? .white.opacity(0.2) : .black),
                    alignment: .top
                )
        )
    }
}

#Preview {
    VStack {
        Spacer()
        BottomNavBar(selectedTab: .constant(.dashboard))
    }
    .background(Color.backgroundLight)
}
