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
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
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
            
            // Central Card
            ZStack {
                // Glow
                Circle()
                    .fill(Color.neoCyan.opacity(0.2))
                    .frame(width: 250, height: 250)
                    .blur(radius: 40)
                
                RoundedRectangle(cornerRadius: 32)
                    .fill(Color.backgroundDark)
                    .frame(width: 240, height: 240)
                    .overlay(
                        RoundedRectangle(cornerRadius: 32)
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .rotationEffect(.degrees(-5))
                
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 100))
                    .foregroundColor(.neoCyan)
                
                // Floating icons
                Image(systemName: "bolt.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.black)
                    .frame(width: 48, height: 48)
                    .background(Color.primaryYellow)
                    .clipShape(Circle())
                    .offset(x: 110, y: -110)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    .frame(width: 44, height: 44)
                    .background(Color.white)
                    .clipShape(Circle())
                    .offset(x: -110, y: 100)
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
            
            // Stacked Cards
            ZStack {
                NeubrutalistCard(backgroundColor: .neoLime) {
                    HStack {
                        Image(systemName: "figure.yoga")
                        Text("Yoga")
                    }
                    .font(.displayBold(18))
                }
                .frame(width: 200)
                .offset(x: 20, y: 60)
                
                NeubrutalistCard(backgroundColor: .neoMagenta) {
                    HStack {
                        Image(systemName: "terminal")
                        Text("Review PRs")
                    }
                    .font(.displayBold(18))
                }
                .frame(width: 220)
                .offset(x: -20, y: 0)
                
                NeubrutalistCard(backgroundColor: .neoCyan) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "pencil.and.outline")
                            Text("Design System")
                        }
                        .font(.displayBold(20))
                    }
                }
                .frame(width: 240)
                .offset(x: 10, y: -60)
                .overlay(
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.neoCyan)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white, lineWidth: 2))
                        .offset(x: 100, y: -100)
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
            .background(Color.white)
            .cornerRadius(32)
            .overlay(RoundedRectangle(cornerRadius: 32).stroke(Color.black, lineWidth: 3))
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
            
            NeubrutalistButton.primary(
                title: currentStep == .recaps ? "GET STARTED" : (currentStep == .welcome ? "NEXT STEP" : "NEXT"),
                icon: currentStep == .recaps ? "arrow.right" : nil
            ) {
                if let next = OnboardingStep(rawValue: currentStep.rawValue + 1) {
                    currentStep = next
                } else {
                    showLogin = true
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    WelcomeView()
}
