//
//  CircularProgressView.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import SwiftUI

struct CircularProgressView: View {
    let progress: Double // 0.0 to 1.0
    let lineWidth: CGFloat
    let backgroundColor: Color
    let foregroundColor: Color
    
    init(
        progress: Double,
        lineWidth: CGFloat = 8,
        backgroundColor: Color = Color.black.opacity(0.1),
        foregroundColor: Color = .black
    ) {
        self.progress = progress
        self.lineWidth = lineWidth
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(backgroundColor, lineWidth: lineWidth)
            
            // Progress circle
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    foregroundColor,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .butt
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)
        }
    }
}

// MARK: - Focus Score Display
struct FocusScoreView: View {
    @Environment(\.colorScheme) var colorScheme
    let score: Int
    let progress: Double
    let message: String
    
    var body: some View {
        ZStack {
            CircularProgressView(
                progress: progress,
                lineWidth: 10,
                backgroundColor: colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.12),
                foregroundColor: colorScheme == .dark ? .neoCyan : .neoCyan
            )
            .padding(24)
            
            VStack(spacing: 8) {
                Text("Focus Score")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary)
                Text("\(score)")
                    .font(.system(size: 72, weight: .bold, design: .rounded))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                Text(message)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.ultraThinMaterial, in: Capsule())
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    VStack {
        FocusScoreView(
            score: 84,
            progress: 0.84,
            message: "You are on fire today!"
        )
        .frame(width: 300, height: 300)
    }
    .padding()
}
