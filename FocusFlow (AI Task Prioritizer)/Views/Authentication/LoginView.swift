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
            // Background gradient behind glass
            LinearGradient(colors: [Color.black.opacity(0.85), Color.blue.opacity(0.55), Color.purple.opacity(0.45)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            // Subtle bokeh lights
            ZStack {
                Circle().fill(Color.white.opacity(0.08)).blur(radius: 60).frame(width: 220, height: 220).offset(x: -140, y: -280)
                Circle().fill(Color.cyan.opacity(0.10)).blur(radius: 80).frame(width: 260, height: 260).offset(x: 150, y: -200)
                Circle().fill(Color.purple.opacity(0.10)).blur(radius: 90).frame(width: 300, height: 300).offset(x: 100, y: 340)
            }
            .allowsHitTesting(false)

            VStack(spacing: 20) {
                // Top bar
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(.white.opacity(0.25), lineWidth: 1))
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)

                Spacer(minLength: 10)

                // Header
                VStack(spacing: 12) {
                    Text("FOCUS\nFLOW")
                        .font(.system(size: 52, weight: .black, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 6)
                    Text("Master your tasks.")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.white.opacity(0.9))
                }
                .glassBackground(cornerRadius: 24)
                .padding(.horizontal, 24)

                // Login form
                VStack(spacing: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "envelope").font(.system(size: 14, weight: .semibold))
                            Text("Email").font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundStyle(.white.opacity(0.9))
                        TextField("name@example.com", text: $email)
                            .font(.system(size: 16))
                            .padding(.horizontal, 16)
                            .frame(height: 52)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(.white.opacity(0.25), lineWidth: 1))
                            .foregroundStyle(.white)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "lock").font(.system(size: 14, weight: .semibold))
                            Text("Password").font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundStyle(.white.opacity(0.9))
                        SecureField("••••••••", text: $password)
                            .font(.system(size: 16))
                            .padding(.horizontal, 16)
                            .frame(height: 52)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(.white.opacity(0.25), lineWidth: 1))
                            .foregroundStyle(.white)
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            Task {
                                if !email.isEmpty { try? await authService.resetPassword(email: email) }
                            }
                        }) {
                            Text("Forgot Password?")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.white.opacity(0.9))
                                .underline()
                        }
                    }
                    Button(action: handleLogin) {
                        HStack(spacing: 8) {
                            if authService.isLoading {
                                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Log in").font(.system(size: 16, weight: .semibold))
                                Image(systemName: "arrow.right").font(.system(size: 14, weight: .semibold))
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.neoCyan)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(.white.opacity(0.3), lineWidth: 1))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(authService.isLoading)

                    HStack {
                        Rectangle().fill(Color.white.opacity(0.25)).frame(height: 1)
                        Text("or").font(.system(size: 13, weight: .medium)).foregroundStyle(.white.opacity(0.8))
                        Rectangle().fill(Color.white.opacity(0.25)).frame(height: 1)
                    }
                    .padding(.vertical, 6)

                    VStack(spacing: 12) {
                        Button(action: { Task { try? await authService.signInWithGoogle() } }) {
                            HStack(spacing: 12) {
                                Image(systemName: "g.circle.fill").font(.system(size: 20))
                                Text("Continue with Google").font(.system(size: 15, weight: .semibold))
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
                            .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(.white.opacity(0.25), lineWidth: 1))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .glassBackground(cornerRadius: 24)
                .padding(.horizontal, 24)

                Spacer()

                // Bottom decorative stripe replaced by a thin glass bar
                Color.clear.frame(height: 1)
                    .overlay(Rectangle().fill(Color.white.opacity(0.25)).frame(height: 1))
                    .padding(.horizontal, 24)
                    .padding(.bottom, 8)
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
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "envelope")
                        .font(.system(size: 14, weight: .semibold))
                    Text("Email")
                        .font(.system(size: 13, weight: .semibold))
                }
                .foregroundColor(.black)
                TextField("name@example.com", text: $email)
                    .font(.system(size: 16))
                    .padding(.horizontal, 16)
                    .frame(height: 52)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(.white.opacity(0.25), lineWidth: 1))
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "lock")
                        .font(.system(size: 14, weight: .semibold))
                    Text("Password")
                        .font(.system(size: 13, weight: .semibold))
                }
                .foregroundColor(.black)
                SecureField("••••••••", text: $password)
                    .font(.system(size: 16))
                    .padding(.horizontal, 16)
                    .frame(height: 52)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(.white.opacity(0.25), lineWidth: 1))
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
            
            Button(action: handleLogin) {
                HStack(spacing: 8) {
                    if authService.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Log in")
                            .font(.system(size: 16, weight: .semibold))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color.neoCyan)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(.white.opacity(0.3), lineWidth: 1))
            }
            .disabled(authService.isLoading)
            .padding(.top, 8)
            
            HStack {
                Rectangle().fill(Color.black.opacity(0.2)).frame(height: 1)
                Text("or")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)
                Rectangle().fill(Color.black.opacity(0.2)).frame(height: 1)
            }
            .padding(.vertical, 8)
            
            VStack(spacing: 12) {
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
    
    private func socialLoginLabel(icon: String, title: String, color: Color = .black) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color == .black ? .black : color)
            Text(title)
                .font(.system(size: 15, weight: .semibold))
        }
        .foregroundColor(.black)
        .frame(maxWidth: .infinity)
        .frame(height: 52)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(.white.opacity(0.25), lineWidth: 1))
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

