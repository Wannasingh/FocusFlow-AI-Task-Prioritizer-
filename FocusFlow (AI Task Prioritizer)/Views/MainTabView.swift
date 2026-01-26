//
//  MainTabView.swift
//  FocusFlow (AI Task Prioritizer)
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: NavTab = .dashboard
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main Content Area
            Group {
                switch selectedTab {
                case .dashboard:
                    DashboardView()
                case .tasks:
                    TaskListView()
                case .insights:
                    FocusStatisticsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, 80) // Space for bottom nav
            
            // Shared Bottom Navigation
            BottomNavBar(selectedTab: $selectedTab)
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(colorScheme == .dark ? Color.backgroundDarkAlt : Color.backgroundLight)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthService())
}
