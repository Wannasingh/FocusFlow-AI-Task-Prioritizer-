//
//  FocusFlow__AI_Task_Prioritizer_App.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import SwiftUI

@main
struct FocusFlow__AI_Task_Prioritizer_App: App {
    @StateObject private var authService = AuthService()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authService.isAuthenticated {
                    ContentView()
                        .environmentObject(authService)
                } else {
                    WelcomeView()
                        .environmentObject(authService)
                }
            }
            .onOpenURL { url in
                Task {
                    try? await authService.handleOAuthCallback(url: url)
                }
            }
        }
    }
}


