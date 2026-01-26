//
//  LoginView.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showSignUp = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            // Background
            (colorScheme == .dark ? Color.backgroundDark : Color.backgroundLight)
                .ignoresSafeArea()
            
            // Decorative elements
            decorativeElements
            
            // Main content
            VStack(spacing: 32) {
                Spacer()
                
                // Header
                header
                
                // Login form
                loginForm
                
                // Footer
                footer
                
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .sheet(isPresented: $showSignUp) {
            SignUpView()
        }
    }
    
    // MARK: - Decorative Elements
    private var decorativeElements: some View {
        ZStack {
            // Large circle - top left
            Circle()
                .fill(Color.primaryYellow)
                .frame(width: 256, height: 256)
                .overlay(
                    Circle()
                        .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 4)
                )
                .opacity(0.8)
                .offset(x: -100, y: -280)
            
            // Square - bottom right
            Rectangle()
                .fill(Color.clear)
                .frame(width: 192, height: 192)
                .overlay(
                    Rectangle()
                        .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 4)
                )
                .rotationEffect(.degrees(12))
                .offset(x: 150, y: 350)
            
            // Small circle - top right (mobile)
            Circle()
                .fill(colorScheme == .dark ? Color.primaryYellow : Color.black)
                .frame(width: 48, height: 48)
                .offset(x: 150, y: -300)
            
            // Small square - bottom left (mobile)
            Rectangle()
                .fill(Color.clear)
                .frame(width: 64, height: 64)
                .overlay(
                    Rectangle()
                        .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 4)
                )
                .rotationEffect(.degrees(45))
                .offset(x: -150, y: 350)
        }
    }
    
    // MARK: - Header
    private var header: some View {
        VStack(spacing: 16) {
            Text("FOCUS\nFLOW")
                .font(.system(size: 64, weight: .black, design: .rounded))
                .tracking(-2)
                .multilineTextAlignment(.center)
                .foregroundColor(colorScheme == .dark ? .white : .textPrimary)
            
            Text("Master your tasks.")
                .font(.displayBold(16))
                .foregroundColor(colorScheme == .dark ? .white : .textPrimary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(colorScheme == .dark ? Color.black.opacity(0.2) : Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(colorScheme == .dark ? Color.white.opacity(0.1) : Color.clear, lineWidth: 2)
                )
                .cornerRadius(4)
        }
    }
    
    // MARK: - Login Form
    private var loginForm: some View {
        VStack(spacing: 24) {
            NeubrutalistTextField(
                label: "Email",
                icon: "envelope",
                placeholder: "name@example.com",
                text: $email
            )
            
            NeubrutalistTextField(
                label: "Password",
                icon: "lock",
                placeholder: "••••••••",
                text: $password,
                isSecure: true
            )
            
            // Forgot password
            HStack {
                Spacer()
                Button(action: {}) {
                    Text("Forgot Password?")
                        .font(.displayBold(14))
                        .foregroundColor(colorScheme == .dark ? .white : .textPrimary)
                        .underline()
                }
            }
            
            // Login button
            NeubrutalistButton.primary(title: "Login", icon: "arrow.right") {
                // TODO: Implement login
            }
            .padding(.top, 8)
        }
    }
    
    // MARK: - Footer
    private var footer: some View {
        HStack(spacing: 4) {
            Text("Don't have an account?")
                .font(.bodyMedium(16))
                .foregroundColor(colorScheme == .dark ? .white : .textPrimary)
            
            Button(action: { showSignUp = true }) {
                Text("Sign Up")
                    .font(.displayBlack(16))
                    .foregroundColor(.black)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.primaryYellow)
                    .underline()
            }
        }
    }
    
    // MARK: - Bottom Stripe
    private var bottomStripe: some View {
        HStack(spacing: 0) {
            ForEach(0..<6) { index in
                Rectangle()
                    .fill(index % 2 == 0 ? Color.primaryYellow : (colorScheme == .dark ? Color.white : Color.black))
                    .frame(height: 8)
            }
        }
    }
}

#Preview {
    LoginView()
}
