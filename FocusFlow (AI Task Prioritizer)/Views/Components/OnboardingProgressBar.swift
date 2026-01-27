//
//  OnboardingProgressBar.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 27/1/2569 BE.
//

import SwiftUI

struct OnboardingProgressBar: View {
    let currentStep: OnboardingStep
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.black)
                    .frame(height: 8)
                
                Rectangle()
                    .fill(Color.primaryYellow)
                    .frame(width: progressWidth(in: geometry.size.width), height: 8)
            }
        }
        .frame(height: 8)
    }
    
    private func progressWidth(in totalWidth: CGFloat) -> CGFloat {
        let stepCount = CGFloat(OnboardingStep.allCases.count)
        let current = CGFloat(currentStep.stepNumber)
        return totalWidth * (current / stepCount)
    }
}

#Preview {
    VStack(spacing: 20) {
        OnboardingProgressBar(currentStep: .welcome)
        OnboardingProgressBar(currentStep: .priorities)
        OnboardingProgressBar(currentStep: .recaps)
    }
    .padding()
    .background(Color.backgroundDark)
}
