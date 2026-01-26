//
//  SignUpView.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import SwiftUI

struct SignUpView: View {
    @State private var displayName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                (colorScheme == .dark ? Color.backgroundDark : Color.backgroundLight)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Header
                        VStack(spacing: 16) {
                            Text("JOIN\nFOCUSFLOW")
                                .font(.system(size: 56, weight: .black, design: .rounded))
                                .tracking(-2)
                                .multilineTextAlignment(.center)
                                .foregroundColor(colorScheme == .dark ? .white : .textPrimary)
                            
                            Text("Start your productivity journey")
                                .font(.displayBold(14))
                                .foregroundColor(colorScheme == .dark ? .white : .textPrimary)
                        }
                        .padding(.top, 40)
                        
                        // Sign up form
                        VStack(spacing: 24) {
                            NeubrutalistTextField(
                                label: "Display Name",
                                icon: "person",
                                placeholder: "Your Name",
                                text: $displayName
                            )
                            
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
                            
                            NeubrutalistTextField(
                                label: "Confirm Password",
                                icon: "lock.fill",
                                placeholder: "••••••••",
                                text: $confirmPassword,
                                isSecure: true
                            )
                            
                            // Sign up button
                            NeubrutalistButton.primary(title: "Create Account", icon: "checkmark") {
                                // TODO: Implement sign up
                            }
                            .padding(.top, 8)
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
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .frame(width: 40, height: 40)
                            .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 2)
                            )
                    }
                }
            }
        }
    }
}

#Preview {
    SignUpView()
}
