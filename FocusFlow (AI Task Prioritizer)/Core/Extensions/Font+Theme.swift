//
//  Font+Theme.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import SwiftUI

extension Font {
    // MARK: - Display Font (Space Grotesk equivalent - using SF Pro Rounded)
    static func displayBlack(_ size: CGFloat) -> Font {
        .system(size: size, weight: .black, design: .rounded)
    }
    
    static func displayBold(_ size: CGFloat) -> Font {
        .system(size: size, weight: .bold, design: .rounded)
    }
    
    static func displaySemibold(_ size: CGFloat) -> Font {
        .system(size: size, weight: .semibold, design: .rounded)
    }
    
    static func displayMedium(_ size: CGFloat) -> Font {
        .system(size: size, weight: .medium, design: .rounded)
    }
    
    static func displayRegular(_ size: CGFloat) -> Font {
        .system(size: size, weight: .regular, design: .rounded)
    }
    
    // MARK: - Body Font (Noto Sans equivalent - using SF Pro)
    static func bodyBold(_ size: CGFloat) -> Font {
        .system(size: size, weight: .bold, design: .default)
    }
    
    static func bodyMedium(_ size: CGFloat) -> Font {
        .system(size: size, weight: .medium, design: .default)
    }
    
    static func bodyRegular(_ size: CGFloat) -> Font {
        .system(size: size, weight: .regular, design: .default)
    }
    
    // MARK: - Mono Font
    static func mono(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .monospaced)
    }
}
