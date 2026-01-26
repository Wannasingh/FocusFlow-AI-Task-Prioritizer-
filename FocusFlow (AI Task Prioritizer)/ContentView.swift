//
//  ContentView.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        if authService.isAuthenticated {
            MainTabView()
                .environmentObject(authService)
        } else {
            // This should technically be handled by the App struct, 
            // but we keep it here as a fallback
            WelcomeView()
                .environmentObject(authService)
        }
    }
}



#Preview {
    ContentView()
}
