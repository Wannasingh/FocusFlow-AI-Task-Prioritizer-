//
//  NeubrutalistBadge.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import SwiftUI

struct NeubrutalistBadge: View {
    let text: String
    let icon: String?
    let backgroundColor: Color
    let foregroundColor: Color
    let borderColor: Color
    
    init(
        text: String,
        icon: String? = nil,
        backgroundColor: Color = .white,
        foregroundColor: Color = .black,
        borderColor: Color = .black
    ) {
        self.text = text
        self.icon = icon
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.borderColor = borderColor
    }
    
    var body: some View {
        HStack(spacing: 4) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .bold))
            }
            
            Text(text)
                .font(.displayBold(10))
                .textCase(.uppercase)
                .tracking(0.5)
        }
        .foregroundColor(foregroundColor)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(backgroundColor)
        .cornerRadius(4)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(borderColor, lineWidth: 2)
        )
    }
}

#Preview {
    VStack(spacing: 12) {
        NeubrutalistBadge(text: "High Priority")
        NeubrutalistBadge(text: "AI Prioritized", icon: "sparkles", backgroundColor: .neoYellow)
        NeubrutalistBadge(text: "In Progress", backgroundColor: .black, foregroundColor: .white, borderColor: .white)
    }
    .padding()
}
