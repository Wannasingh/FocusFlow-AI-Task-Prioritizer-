//
//  SignUpView.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authService: AuthService
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
                LinearGradient(colors: [Color.black.opacity(0.9), Color.indigo.opacity(0.6), Color.purple.opacity(0.5)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                ZStack {
                    Circle().fill(Color.white.opacity(0.07)).blur(radius: 70).frame(width: 240, height: 240).offset(x: -120, y: -260)
                    Circle().fill(Color.cyan.opacity(0.10)).blur(radius: 90).frame(width: 280, height: 280).offset(x: 160, y: -120)
                    Circle().fill(Color.purple.opacity(0.10)).blur(radius: 100).frame(width: 320, height: 320).offset(x: -60, y: 360)
                }
                .allowsHitTesting(false)

                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 12) {
                            Text("JOIN\nFOCUSFLOW")
                                .font(.system(size: 52, weight: .black, design: .rounded))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white)
                                .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 6)
                            Text("Start your productivity journey")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.white.opacity(0.9))
                        }
                        .glassBackground(cornerRadius: 24)
                        .padding(.top, 24)

                        VStack(spacing: 18) {
                            VStack(alignment: .leading, spacing: 8) {
                                labelRow(icon: "person", title: "Display name")
                                TextField("Your Name", text: $displayName)
                                    .font(.system(size: 16))
                                    .padding(.horizontal, 16)
                                    .frame(height: 52)
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(.white.opacity(0.25), lineWidth: 1))
                                    .foregroundStyle(.white)
                            }
                            VStack(alignment: .leading, spacing: 8) {
                                labelRow(icon: "envelope", title: "Email")
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
                                labelRow(icon: "lock", title: "Password")
                                SecureField("••••••••", text: $password)
                                    .font(.system(size: 16))
                                    .padding(.horizontal, 16)
                                    .frame(height: 52)
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(.white.opacity(0.25), lineWidth: 1))
                                    .foregroundStyle(.white)
                            }
                            VStack(alignment: .leading, spacing: 8) {
                                labelRow(icon: "lock.fill", title: "Confirm password")
                                SecureField("••••••••", text: $confirmPassword)
                                    .font(.system(size: 16))
                                    .padding(.horizontal, 16)
                                    .frame(height: 52)
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(.white.opacity(0.25), lineWidth: 1))
                                    .foregroundStyle(.white)
                            }

                            Button(action: handleSignUp) {
                                HStack(spacing: 8) {
                                    if authService.isLoading {
                                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    } else {
                                        Text("Create account").font(.system(size: 16, weight: .semibold))
                                        Image(systemName: "checkmark").font(.system(size: 14, weight: .semibold))
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
                        }
                        .glassBackground(cornerRadius: 24)

                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 40)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(.white.opacity(0.25), lineWidth: 1))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .alert("Error", isPresented: $showError) { Button("OK", role: .cancel) {} } message: { Text(authService.errorMessage ?? "An error occurred") }
        .alert("Success!", isPresented: $showSuccess) { Button("OK") { dismiss() } } message: { Text("Account created successfully! Please check your email to verify your account.") }
    }
    
    private func labelRow(icon: String, title: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
            Text(title)
                .font(.system(size: 13, weight: .semibold))
        }
        .foregroundStyle(.white.opacity(0.9))
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
        .environmentObject(AuthService())
}
