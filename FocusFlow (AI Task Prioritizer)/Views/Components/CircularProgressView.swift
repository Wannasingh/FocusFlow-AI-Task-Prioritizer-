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
    let score: Int
    let progress: Double
    let message: String
    
    var body: some View {
        ZStack {
            // Circular progress
            CircularProgressView(
                progress: progress,
                lineWidth: 12,
                backgroundColor: Color.black.opacity(0.1),
                foregroundColor: .black
            )
            .padding(24)
            
            // Content
            VStack(spacing: 8) {
                Text("FOCUS SCORE")
                    .font(.displayBold(14))
                    .tracking(2)
                    .padding(.bottom, 4)
                    .overlay(
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(.black),
                        alignment: .bottom
                    )
                
                Text("\(score)")
                    .font(.system(size: 100, weight: .black, design: .rounded))
                    .tracking(-4)
                
                Text(message)
                    .font(.displayBold(12))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(Color.black)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .rotationEffect(.degrees(-2))
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .background(Color.neoYellow)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(Color.black, lineWidth: 4)
        )
        .shadow(color: .black, radius: 0, x: 4, y: 4)
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
