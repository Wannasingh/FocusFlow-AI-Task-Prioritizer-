//
//  OnboardingPageIndicator.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 27/1/2569 BE.
//

import SwiftUI

struct OnboardingPageIndicator: View {
    let currentStep: OnboardingStep
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(OnboardingStep.allCases, id: \.self) { step in
                Capsule()
                    .fill(step == currentStep ? Color.primaryYellow : Color.gray.opacity(0.3))
                    .frame(width: step == currentStep ? 24 : 8, height: 8)
                    .overlay(
                        Capsule()
                            .stroke(Color.black, lineWidth: 1)
                    )
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        OnboardingPageIndicator(currentStep: .welcome)
        OnboardingPageIndicator(currentStep: .priorities)
        OnboardingPageIndicator(currentStep: .recaps)
    }
    .padding()
    .background(Color.backgroundDark)
}
