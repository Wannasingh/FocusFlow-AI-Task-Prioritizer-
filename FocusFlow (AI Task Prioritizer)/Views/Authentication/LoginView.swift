//
//  LoginView.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authService: AuthService
    @State private var email = ""
    @State private var password = ""
    @State private var showError = false
    @State private var showSignUp = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Background - clean beige/cream
            Color(hex: "#f8f8f5")
                .ignoresSafeArea()
            
            // Decorative elements
            decorativeElements
            
            // Main content
            VStack(spacing: 0) {
                // Back Button
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                            .frame(width: 44, height: 44)
                            .background(Color.white)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.black, lineWidth: 2))
                    }
                    .padding(.leading, 24)
                    .padding(.top, 16)
                    
                    Spacer()
                }
                
                Spacer()
                
                // Header
                header
                    .padding(.bottom, 40)
                
                // Login form
                loginForm
                    .padding(.horizontal, 32)
                
                Spacer()
                
                // Footer
                footer
                    .padding(.bottom, 40)
                
                // Bottom stripe
                bottomStripe
            }
        }
        .sheet(isPresented: $showSignUp) {
            SignUpView()
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(authService.errorMessage ?? "An error occurred")
        }
    }
    
    // MARK: - Decorative Elements
    private var decorativeElements: some View {
        ZStack {
            // Top right circle
            Circle()
                .fill(Color.black)
                .frame(width: 80, height: 80)
                .offset(x: 150, y: -350)
            
            // Bottom left rotated square
            Rectangle()
                .fill(Color.clear)
                .frame(width: 100, height: 100)
                .overlay(Rectangle().stroke(Color.black, lineWidth: 4))
                .rotationEffect(.degrees(45))
                .offset(x: -150, y: 380)
        }
    }
    
    // MARK: - Header
    private var header: some View {
        VStack(spacing: 16) {
            Text("FOCUS\nFLOW")
                .font(.system(size: 56, weight: .black, design: .rounded))
                .tracking(-2)
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
            
            Text("Master your tasks.")
                .font(.system(size: 18, weight: .medium, design: .default))
                .foregroundColor(.black)
        }
    }
    
    // MARK: - Login Form
    private var loginForm: some View {
        VStack(spacing: 24) {
            // Email Field
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "envelope")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                    Text("EMAIL")
                        .font(.system(size: 14, weight: .bold, design: .default))
                        .foregroundColor(.black)
                        .tracking(1)
                }
                
                TextField("name@example.com", text: $email)
                    .font(.system(size: 16, weight: .regular, design: .default))
                    .padding(.horizontal, 16)
                    .frame(height: 56)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black, lineWidth: 3)
                    )
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
            }
            
            // Password Field
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "lock")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                    Text("PASSWORD")
                        .font(.system(size: 14, weight: .bold, design: .default))
                        .foregroundColor(.black)
                        .tracking(1)
                }
                
                SecureField("••••••••", text: $password)
                    .font(.system(size: 16, weight: .regular, design: .default))
                    .padding(.horizontal, 16)
                    .frame(height: 56)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black, lineWidth: 3)
                    )
            }
            
            // Forgot password
            HStack {
                Spacer()
                Button(action: {
                    Task {
                        if !email.isEmpty {
                            try? await authService.resetPassword(email: email)
                        }
                    }
                }) {
                    Text("Forgot Password?")
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .foregroundColor(.black)
                        .underline()
                }
            }
            
            // Login button
            Button(action: handleLogin) {
                HStack(spacing: 8) {
                    if authService.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    } else {
                        Text("LOGIN")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .tracking(2)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 18, weight: .bold))
                    }
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.primaryYellow)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black, lineWidth: 3)
                )
                .shadow(color: .black, radius: 0, x: 6, y: 6)
            }
            .disabled(authService.isLoading)
            .padding(.top, 8)
            
            // Divider
            HStack {
                Rectangle().fill(Color.black).frame(height: 2)
                Text("OR")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.black)
                Rectangle().fill(Color.black).frame(height: 2)
            }
            .padding(.vertical, 8)
            
            // Social Login Buttons
            VStack(spacing: 12) {
                // Google Sign In
                Button(action: { Task { try? await authService.signInWithGoogle() } }) {
                    socialLoginLabel(icon: "g.circle.fill", title: "Continue with Google")
                }
                
                // Facebook Sign In
                // TODO: Uncomment when Facebook OAuth is configured
                /*
                Button(action: { Task { try? await authService.signInWithFacebook() } }) {
                    socialLoginLabel(icon: "f.circle.fill", title: "Continue with Facebook", color: Color(hex: "#1877F2"))
                }
                */
            }
        }
    }
    
    // Helper for Social Login Buttons
    private func socialLoginLabel(icon: String, title: String, color: Color = .black) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color == .black ? .black : color)
            Text(title)
                .font(.system(size: 16, weight: .bold))
        }
        .foregroundColor(.black)
        .frame(maxWidth: .infinity)
        .frame(height: 56)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 3))
        .shadow(color: .black, radius: 0, x: 4, y: 4)
    }
    
    // MARK: - Footer
    private var footer: some View {
        HStack(spacing: 4) {
            Text("Don't have an account?")
                .font(.system(size: 16, weight: .regular, design: .default))
                .foregroundColor(.black)
            
            Button(action: { showSignUp = true }) {
                Text("Sign Up")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .foregroundColor(.black)
                    .underline()
            }
        }
    }
    
    // MARK: - Bottom Stripe
    private var bottomStripe: some View {
        HStack(spacing: 0) {
            ForEach(0..<6) { index in
                Rectangle()
                    .fill(index % 2 == 0 ? Color.primaryYellow : Color.black)
                    .frame(height: 8)
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    private func handleLogin() {
        guard !email.isEmpty && !password.isEmpty else {
            authService.errorMessage = "Please enter both email and password"
            showError = true
            return
        }
        
        Task {
            do {
                try await authService.signIn(email: email, password: password)
                // App state will update via authService.isAuthenticated
            } catch {
                showError = true
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthService())
}

