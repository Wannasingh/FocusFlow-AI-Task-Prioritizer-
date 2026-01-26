//
//  WelcomeView.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import SwiftUI

struct WelcomeView: View {
    @State private var showLogin = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            // Background
            (colorScheme == .dark ? Color.backgroundDark : Color.backgroundLight)
                .ignoresSafeArea()
            
            // Decorative elements
            decorativeShapes
            
            VStack(spacing: 40) {
                Spacer()
                
                // Logo/Icon
                logo
                
                // Title
                title
                
                // Subtitle
                subtitle
                
                // Features
                features
                
                Spacer()
                
                // CTA Buttons
                ctaButtons
                
                // Bottom stripe
                bottomStripe
            }
        }
        .fullScreenCover(isPresented: $showLogin) {
            LoginView()
        }
    }
    
    // MARK: - Decorative Shapes
    private var decorativeShapes: some View {
        ZStack {
            // Large yellow circle - top right
            Circle()
                .fill(Color.primaryYellow)
                .frame(width: 200, height: 200)
                .overlay(Circle().stroke(Color.black, lineWidth: 4))
                .offset(x: 150, y: -250)
            
            // Rotated square - bottom left
            Rectangle()
                .fill(Color.clear)
                .frame(width: 120, height: 120)
                .overlay(Rectangle().stroke(Color.black, lineWidth: 4))
                .rotationEffect(.degrees(45))
                .offset(x: -140, y: 300)
            
            // Small circle - bottom right
            Circle()
                .fill(Color.primaryGreen)
                .frame(width: 60, height: 60)
                .overlay(Circle().stroke(Color.black, lineWidth: 3))
                .offset(x: 140, y: 350)
        }
    }
    
    // MARK: - Logo
    private var logo: some View {
        ZStack {
            Circle()
                .fill(Color.primaryYellow)
                .frame(width: 120, height: 120)
                .overlay(Circle().stroke(Color.black, lineWidth: 4))
                .shadow(color: .black, radius: 0, x: 6, y: 6)
            
            Image(systemName: "bolt.fill")
                .font(.system(size: 60, weight: .bold))
                .foregroundColor(.black)
        }
    }
    
    // MARK: - Title
    private var title: some View {
        VStack(spacing: 12) {
            Text("FOCUS\nFLOW")
                .font(.system(size: 56, weight: .black, design: .rounded))
                .tracking(-2)
                .multilineTextAlignment(.center)
                .foregroundColor(colorScheme == .dark ? .white : .black)
            
            Rectangle()
                .fill(Color.primaryBlue)
                .frame(width: 100, height: 6)
                .overlay(Rectangle().stroke(Color.black, lineWidth: 2))
        }
    }
    
    // MARK: - Subtitle
    private var subtitle: some View {
        Text("Master your tasks.\nBoost your productivity.")
            .font(.displayBold(16))
            .foregroundColor(colorScheme == .dark ? .white : .textPrimary)
            .multilineTextAlignment(.center)
            .lineSpacing(4)
    }
    
    // MARK: - Features
    private var features: some View {
        VStack(spacing: 16) {
            featureRow(icon: "brain.head.profile", text: "AI-Powered Task Prioritization", color: .neoCyan)
            featureRow(icon: "timer", text: "Focus Timer & Deep Work Sessions", color: .neoMagenta)
            featureRow(icon: "trophy.fill", text: "Gamification & Achievements", color: .neoYellow)
        }
        .padding(.horizontal, 32)
    }
    
    private func featureRow(icon: String, text: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
                .frame(width: 48, height: 48)
                .background(color)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black, lineWidth: 3)
                )
                .shadow(color: .black, radius: 0, x: 3, y: 3)
            
            Text(text)
                .font(.bodyBold(14))
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    // MARK: - CTA Buttons
    private var ctaButtons: some View {
        VStack(spacing: 16) {
            NeubrutalistButton.primary(title: "Get Started", icon: "arrow.right") {
                showLogin = true
            }
            
            Button(action: { showLogin = true }) {
                Text("Already have an account? Login")
                    .font(.bodyBold(14))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .underline()
            }
        }
        .padding(.horizontal, 32)
    }
    
    // MARK: - Bottom Stripe
    private var bottomStripe: some View {
        HStack(spacing: 0) {
            ForEach(0..<8) { index in
                Rectangle()
                    .fill(index % 2 == 0 ? Color.primaryYellow : (colorScheme == .dark ? Color.white : Color.black))
                    .frame(height: 8)
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    WelcomeView()
}
