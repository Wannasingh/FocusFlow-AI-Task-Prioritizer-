//
//  WelcomeView.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import SwiftUI

struct WelcomeView: View {
    @State private var currentStep: OnboardingStep = .welcome
    @State private var showLogin = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            // Background
            Color.backgroundDarkDeep
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                header
                
                // Content based on step
                Group {
                    switch currentStep {
                    case .welcome:
                        welcomeStep
                    case .priorities:
                        prioritiesStep
                    case .recaps:
                        recapsStep
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
                
                Spacer()
                
                // Bottom Section
                bottomSection
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentStep)
        .fullScreenCover(isPresented: $showLogin) {
            LoginView()
        }
    }
    
    // MARK: - Header
    private var header: some View {
        VStack(spacing: 16) {
            HStack {
                if currentStep != .welcome {
                    Button(action: {
                        if let prev = OnboardingStep(rawValue: currentStep.rawValue - 1) {
                            currentStep = prev
                        }
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(.ultraThinMaterial, in: Circle())
                            .overlay(Circle().strokeBorder(.white.opacity(0.2), lineWidth: 1))
                    }
                } else {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.primaryYellow)
                            .frame(width: 12, height: 12)
                        Text("FOCUSFLOW")
                            .font(.displayBlack(14))
                            .foregroundColor(.white)
                    }
                }
                
                Spacer()
                
                if currentStep == .welcome {
                    Button(action: { showLogin = true }) {
                        Text("SKIP")
                            .font(.displayBold(14))
                            .foregroundColor(.gray)
                    }
                } else {
                    Text("STEP \(currentStep.stepNumber) OF 3")
                        .font(.displayBold(14))
                        .foregroundColor(.white)
                }
                
                if currentStep != .welcome {
                    Spacer()
                        .frame(width: 44) // Balance the back button
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            
            if currentStep != .welcome {
                OnboardingProgressBar(currentStep: currentStep)
                    .padding(.horizontal, 24)
            }
        }
    }
    
    // MARK: - Step 1: Welcome
    private var welcomeStep: some View {
        VStack(spacing: 32) {
            Text("WELCOME")
                .font(.displayBlack(72))
                .foregroundColor(.white)
                .overlay(
                    Rectangle()
                        .fill(Color.primaryYellow)
                        .frame(height: 4)
                        .offset(y: 45),
                    alignment: .bottom
                )
                .padding(.top, 20)
            
            ZStack {
                Circle()
                    .fill(Color.neoCyan.opacity(0.15))
                    .frame(width: 220, height: 220)
                    .blur(radius: 30)
                
                RoundedRectangle(cornerRadius: 28)
                    .frame(width: 220, height: 220)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28))
                    .overlay(RoundedRectangle(cornerRadius: 28).strokeBorder(.white.opacity(0.3), lineWidth: 1))
                    .rotationEffect(.degrees(-4))
                
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 80))
                    .foregroundColor(.neoCyan)
                
                Image(systemName: "bolt.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    .frame(width: 44, height: 44)
                    .background(.thinMaterial, in: Circle())
                    .overlay(Circle().strokeBorder(.white.opacity(0.3), lineWidth: 1))
                    .offset(x: 100, y: -100)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 18))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(.thinMaterial, in: Circle())
                    .overlay(Circle().strokeBorder(.white.opacity(0.25), lineWidth: 1))
                    .offset(x: -100, y: 90)
            }
            .padding(.vertical, 40)
            
            VStack(spacing: 16) {
                Text("AI-POWERED FOCUS")
                    .font(.displayBlack(28))
                    .foregroundColor(.white)
                
                Text("Next generation task management\ndriven by neural focus tracking.")
                    .font(.bodyMedium(16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
        }
    }
    
    // MARK: - Step 2: Priorities
    private var prioritiesStep: some View {
        VStack(spacing: 32) {
            Text("SMART\nPRIORITIES")
                .font(.displayBlack(44))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .italic()
                .padding(.top, 20)
            
            ZStack {
                GlassCard(cornerRadius: 16) {
                    HStack {
                        Image(systemName: "figure.yoga")
                        Text("Yoga")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                }
                .frame(width: 200)
                .offset(x: 20, y: 60)
                
                GlassCard(cornerRadius: 16) {
                    HStack {
                        Image(systemName: "terminal")
                        Text("Review PRs")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                }
                .frame(width: 220)
                .offset(x: -20, y: 0)
                
                GlassCard(cornerRadius: 16) {
                    HStack {
                        Image(systemName: "pencil.and.outline")
                        Text("Design System")
                    }
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                }
                .frame(width: 240)
                .offset(x: 10, y: -60)
                .overlay(
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.white)
                        .frame(width: 48, height: 48)
                        .background(Color.neoCyan.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(.white.opacity(0.3), lineWidth: 1))
                        .offset(x: 90, y: -90)
                )
            }
            .padding(.vertical, 60)
            
            VStack(spacing: 16) {
                Text("Our AI analyzes your deadlines\nand energy levels to rank your\ntasks. Focus on what matters,\nignore the noise.")
                    .font(.bodyMedium(16))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 40)
        }
    }
    
    // MARK: - Step 3: Recaps
    private var recapsStep: some View {
        VStack(spacing: 32) {
            VStack(spacing: 0) {
                Text("DAILY")
                    .font(.displayBlack(56))
                    .foregroundColor(.white)
                Text("RECAPS")
                    .font(.displayBlack(56))
                    .foregroundColor(.primaryYellow)
            }
            .padding(.top, 20)
            
            // Dashboard Preview Card
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "sparkles")
                        Text("AI MAGIC")
                    }
                    .font(.system(size: 12, weight: .bold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.neoCyan)
                    .cornerRadius(20)
                    .overlay(Capsule().stroke(Color.black, lineWidth: 1.5))
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 12).cornerRadius(6)
                    Rectangle().fill(Color.gray.opacity(0.3)).frame(width: 150, height: 12).cornerRadius(6)
                }
                
                VStack(spacing: 15) {
                    HStack {
                        Text("FOCUS SCORE")
                            .font(.system(size: 10, weight: .bold))
                        Spacer()
                        Text("92%")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.primaryYellow)
                    }
                    OnboardingProgressBar(currentStep: .recaps) // Reuse progress bar for score
                    
                    HStack {
                        Text("TASKS DONE")
                            .font(.system(size: 10, weight: .bold))
                        Spacer()
                        Text("12/14")
                            .font(.system(size: 10, weight: .bold))
                    }
                    Rectangle().fill(Color.neoCyan).frame(height: 8).cornerRadius(4)
                }
                
                // Bar Chart Placeholder
                HStack(alignment: .bottom, spacing: 10) {
                    ForEach([20, 30, 45, 80, 50, 70], id: \.hashValue) { height in
                        Rectangle()
                            .fill(height == 80 ? Color.primaryYellow : Color.gray.opacity(0.5))
                            .frame(width: 30, height: CGFloat(height))
                            .cornerRadius(4)
                    }
                }
                .frame(height: 80)
            }
            .padding(24)
            .glassBackground(cornerRadius: 24)
            .padding(.horizontal, 32)
            
            VStack(spacing: 16) {
                Text("Get a personalized AI summary of\nyour wins, pending tasks, and focus\ntrends every evening. **Close your\nday with clarity.**")
                    .font(.bodyMedium(16))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                
                Rectangle()
                    .fill(Color.primaryYellow)
                    .frame(width: 150, height: 2)
                    .offset(y: -8)
            }
            .padding(.horizontal, 40)
        }
    }
    
    // MARK: - Bottom Section
    private var bottomSection: some View {
        VStack(spacing: 24) {
            if currentStep != .recaps {
                OnboardingPageIndicator(currentStep: currentStep)
            }
            
            Button(action: {
                if let next = OnboardingStep(rawValue: currentStep.rawValue + 1) {
                    currentStep = next
                } else {
                    showLogin = true
                }
            }) {
                HStack(spacing: 8) {
                    Text(currentStep == .recaps ? "Get started" : (currentStep == .welcome ? "Next step" : "Next"))
                        .font(.system(size: 16, weight: .semibold))
                    if currentStep == .recaps {
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
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    WelcomeView()
}
