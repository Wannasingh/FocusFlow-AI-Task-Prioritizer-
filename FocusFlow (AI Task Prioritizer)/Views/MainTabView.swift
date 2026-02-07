//
//  MainTabView.swift
//  FocusFlow (AI Task Prioritizer)
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: NavTab = .home
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        VStack(spacing: 0) {
            // Content – ได้พื้นที่เท่ากันทุก tab (ความสูง = ทั้งจอ ลบ 64pt ของแถบ)
            Group {
                switch selectedTab {
                case .home:
                    DashboardView()
                case .tasks:
                    TaskListView()
                case .focus:
                    FocusTimerView()
                case .profile:
                    UserProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // แถบล่าง – เป็น view ตัวที่ 2 ใน VStack ตำแหน่งคงที่ทุก tab
            BottomNavBar(selectedTab: $selectedTab)
                .frame(height: BottomNavBar.barHeight)
                .background(.ultraThinMaterial)
                .overlay(Rectangle().fill(Color.white.opacity(0.15)).frame(height: 0.5), alignment: .top)
        }
        .background(
            LinearGradient(colors: [Color.black.opacity(0.92), Color.indigo.opacity(0.6), Color.purple.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthService())
}
