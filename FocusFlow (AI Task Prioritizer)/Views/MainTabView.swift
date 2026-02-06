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
        }
        .background(colorScheme == .dark ? Color.backgroundDarkAlt : Color.backgroundLight)
        .overlay(alignment: .topTrailing) {
            Button(action: {
                Task {
                    try? await authService.signOut()
                }
            }) {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                    Text("Logout (Test)")
                }
                .font(.bodyBold(10))
                .padding(8)
                .background(Color.neoMagenta)
                .foregroundColor(.black)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 2))
                .shadow(color: .black, radius: 0, x: 2, y: 2)
            }
            .padding(.trailing, 16)
            .padding(.top, 50)
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthService())
}
