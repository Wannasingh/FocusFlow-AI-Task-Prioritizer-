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
        ZStack(alignment: .bottom) {
            // Main Content Area
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
            .padding(.bottom, 80) // Space for bottom nav
            
            // Shared Bottom Navigation
            BottomNavBar(selectedTab: $selectedTab)
            
            // TEST LOGOUT BUTTON
            VStack {
                HStack {
                    Spacer()
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
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(colorScheme == .dark ? Color.backgroundDarkAlt : Color.backgroundLight)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthService())
}
