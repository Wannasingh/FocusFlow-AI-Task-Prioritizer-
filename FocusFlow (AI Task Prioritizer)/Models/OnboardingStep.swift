//
//  OnboardingStep.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 27/1/2569 BE.
//

import Foundation

enum OnboardingStep: Int, CaseIterable {
    case welcome = 0
    case priorities = 1
    case recaps = 2
    
    var stepNumber: Int {
        return self.rawValue + 1
    }
}
