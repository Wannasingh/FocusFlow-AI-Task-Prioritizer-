//
//  SignUpView.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var authService = AuthService()
    @State private var displayName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showError = false
    @State private var showSuccess = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color(hex: "#f8f8f5")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Header
                        VStack(spacing: 16) {
                            Text("JOIN\nFOCUSFLOW")
                                .font(.system(size: 56, weight: .black, design: .rounded))
                                .tracking(-2)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                            
                            Text("Start your productivity journey")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                        }
                        .padding(.top, 40)
                        
                        // Sign up form
                        VStack(spacing: 24) {
                            // Display Name
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 8) {
                                    Image(systemName: "person")
                                        .font(.system(size: 16, weight: .bold))
                                    Text("DISPLAY NAME")
                                        .font(.system(size: 14, weight: .bold))
                                        .tracking(1)
                                }
                                .foregroundColor(.black)
                                
                                TextField("Your Name", text: $displayName)
                                    .font(.system(size: 16))
                                    .padding(.horizontal, 16)
                                    .frame(height: 56)
                                    .background(Color.white)
                                    .foregroundColor(.black)
                                    .cornerRadius(12)
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 3))
                            }
                            
                            // Email
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 8) {
                                    Image(systemName: "envelope")
                                        .font(.system(size: 16, weight: .bold))
                                    Text("EMAIL")
                                        .font(.system(size: 14, weight: .bold))
                                        .tracking(1)
                                }
                                .foregroundColor(.black)
                                
                                TextField("name@example.com", text: $email)
                                    .font(.system(size: 16))
                                    .padding(.horizontal, 16)
                                    .frame(height: 56)
                                    .background(Color.white)
                                    .foregroundColor(.black)
                                    .cornerRadius(12)
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 3))
                                    .autocapitalization(.none)
                                    .keyboardType(.emailAddress)
                            }
                            
                            // Password
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 8) {
                                    Image(systemName: "lock")
                                        .font(.system(size: 16, weight: .bold))
                                    Text("PASSWORD")
                                        .font(.system(size: 14, weight: .bold))
                                        .tracking(1)
                                }
                                .foregroundColor(.black)
                                
                                SecureField("••••••••", text: $password)
                                    .font(.system(size: 16))
                                    .padding(.horizontal, 16)
                                    .frame(height: 56)
                                    .background(Color.white)
                                    .foregroundColor(.black)
                                    .cornerRadius(12)
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 3))
                            }
                            
                            // Confirm Password
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 8) {
                                    Image(systemName: "lock.fill")
                                        .font(.system(size: 16, weight: .bold))
                                    Text("CONFIRM PASSWORD")
                                        .font(.system(size: 14, weight: .bold))
                                        .tracking(1)
                                }
                                .foregroundColor(.black)
                                
                                SecureField("••••••••", text: $confirmPassword)
                                    .font(.system(size: 16))
                                    .padding(.horizontal, 16)
                                    .frame(height: 56)
                                    .background(Color.white)
                                    .foregroundColor(.black)
                                    .cornerRadius(12)
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 3))
                            }
                            
                            // Sign up button
                            Button(action: handleSignUp) {
                                HStack(spacing: 8) {
                                    if authService.isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                    } else {
                                        Text("CREATE ACCOUNT")
                                            .font(.system(size: 16, weight: .bold, design: .rounded))
                                            .tracking(2)
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 18, weight: .bold))
                                    }
                                }
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.primaryYellow)
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 3))
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
                                    HStack(spacing: 12) {
                                        Image(systemName: "g.circle.fill")
                                            .font(.system(size: 24))
                                        Text("Continue with Google")
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
                                
                                // Facebook Sign In
                                // TODO: Uncomment when Facebook OAuth is configured
                                /*
                                Button(action: { Task { try? await authService.signInWithFacebook() } }) {
                                    HStack(spacing: 12) {
                                        Image(systemName: "f.circle.fill")
                                            .font(.system(size: 24))
                                        Text("Continue with Facebook")
                                            .font(.system(size: 16, weight: .bold))
                                    }
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(Color(hex: "#1877F2").opacity(0.2))
                                    .cornerRadius(12)
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 3))
                                    .shadow(color: .black, radius: 0, x: 4, y: 4)
                                }
                                */
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .frame(width: 40, height: 40)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
                    }
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(authService.errorMessage ?? "An error occurred")
            }
            .alert("Success!", isPresented: $showSuccess) {
                Button("OK") { dismiss() }
            } message: {
                Text("Account created successfully! Please check your email to verify your account.")
            }
        }
    }
    
    private func handleSignUp() {
        // Validation
        guard !displayName.isEmpty else {
            authService.errorMessage = "Please enter your display name"
            showError = true
            return
        }
        
        guard !email.isEmpty else {
            authService.errorMessage = "Please enter your email"
            showError = true
            return
        }
        
        guard password.count >= 6 else {
            authService.errorMessage = "Password must be at least 6 characters"
            showError = true
            return
        }
        
        guard password == confirmPassword else {
            authService.errorMessage = "Passwords do not match"
            showError = true
            return
        }
        
        // Sign up
        Task {
            do {
                try await authService.signUp(email: email, password: password, displayName: displayName)
                showSuccess = true
            } catch {
                showError = true
            }
        }
    }
}

#Preview {
    SignUpView()
}
