//
//  FocusTimerView.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import SwiftUI

struct FocusTimerView: View {
    @State private var timeRemaining = 1500 // 25 minutes in seconds
    @State private var isRunning = false
    @State private var sessionType: SessionType = .pomodoro
    @Environment(\.colorScheme) var colorScheme
    
    var progress: Double {
        let total = sessionType == .pomodoro ? 1500.0 : 3600.0
        return Double(timeRemaining) / total
    }
    
    var body: some View {
        ZStack {
            (colorScheme == .dark ? Color.backgroundDarkAlt : Color.backgroundLight)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                // Header
                header
                
                Spacer()
                
                // Timer Circle
                timerCircle
                
                // Controls
                controls
                
                Spacer()
                
                // Current Task
                currentTask
                
                Spacer()
            }
            .padding(.horizontal, 24)
        }
    }
    
    // MARK: - Header
    private var header: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .frame(width: 40, height: 40)
                    .background(Color.clear)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 2)
                    )
            }
            
            Spacer()
            
            Text("FOCUS TIMER")
                .font(.displayBold(18))
                .foregroundColor(colorScheme == .dark ? .white : .black)
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .frame(width: 40, height: 40)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 2)
                    )
            }
        }
        .padding(.top, 16)
    }
    
    // MARK: - Timer Circle
    private var timerCircle: some View {
        ZStack {
            // Progress Ring
            CircularProgressView(
                progress: progress,
                lineWidth: 16,
                backgroundColor: Color.black.opacity(0.1),
                foregroundColor: .primaryBlue
            )
            .frame(width: 300, height: 300)
            
            // Time Display
            VStack(spacing: 8) {
                Text(timeString)
                    .font(.system(size: 72, weight: .black, design: .rounded))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .tracking(-2)
                
                Text(sessionType.rawValue.uppercased())
                    .font(.displayBold(14))
                    .foregroundColor(.textSecondary)
                    .tracking(2)
            }
        }
        .padding(32)
        .background(colorScheme == .dark ? Color.backgroundDarkDeep : Color.white)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 4)
        )
        .shadow(color: colorScheme == .dark ? .white : .black, radius: 0, x: 6, y: 6)
    }
    
    // MARK: - Controls
    private var controls: some View {
        HStack(spacing: 20) {
            // Reset Button
            Button(action: resetTimer) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                    .frame(width: 64, height: 64)
                    .background(Color.white)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.black, lineWidth: 3)
                    )
                    .shadow(color: .black, radius: 0, x: 4, y: 4)
            }
            
            // Play/Pause Button
            Button(action: toggleTimer) {
                Image(systemName: isRunning ? "pause.fill" : "play.fill")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 80, height: 80)
                    .background(Color.primaryBlue)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black, lineWidth: 4)
                    )
                    .shadow(color: colorScheme == .dark ? .white : .black, radius: 0, x: 6, y: 6)
            }
            
            // Skip Button
            Button(action: {}) {
                Image(systemName: "forward.end.fill")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                    .frame(width: 64, height: 64)
                    .background(Color.white)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.black, lineWidth: 3)
                    )
                    .shadow(color: .black, radius: 0, x: 4, y: 4)
            }
        }
    }
    
    // MARK: - Current Task
    private var currentTask: some View {
        VStack(spacing: 12) {
            Text("CURRENT TASK")
                .font(.displayBold(12))
                .foregroundColor(.textSecondary)
                .tracking(1.5)
            
            Text("Design System Update")
                .font(.system(size: 24, weight: .black, design: .rounded))
                .foregroundColor(colorScheme == .dark ? .white : .black)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(colorScheme == .dark ? Color.backgroundDarkDeep : Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 3)
        )
        .shadow(color: colorScheme == .dark ? .white : .black, radius: 0, x: 4, y: 4)
    }
    
    // MARK: - Helpers
    private var timeString: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func toggleTimer() {
        isRunning.toggle()
        // TODO: Implement timer logic
    }
    
    private func resetTimer() {
        isRunning = false
        timeRemaining = sessionType == .pomodoro ? 1500 : 3600
    }
}

#Preview {
    FocusTimerView()
}
