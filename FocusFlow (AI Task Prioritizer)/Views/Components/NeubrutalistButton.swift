//
//  NeubrutalistButton.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import SwiftUI

struct NeubrutalistButton: View {
    let title: String
    let icon: String?
    let backgroundColor: Color
    let foregroundColor: Color
    let borderColor: Color
    let shadowColor: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    init(
        title: String,
        icon: String? = nil,
        backgroundColor: Color = .primaryYellow,
        foregroundColor: Color = .black,
        borderColor: Color = .black,
        shadowColor: Color = .black,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.borderColor = borderColor
        self.shadowColor = shadowColor
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(title)
                    .font(.displayBold(16))
                    .textCase(.uppercase)
                    .tracking(1.5)
                
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .bold))
                }
            }
            .foregroundColor(foregroundColor)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(backgroundColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: 3)
            )
            .shadow(color: shadowColor, radius: 0, x: isPressed ? 0 : 6, y: isPressed ? 0 : 6)
            .offset(x: isPressed ? 6 : 0, y: isPressed ? 6 : 0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = false
                    }
                }
        )
    }
}

// MARK: - Variants
extension NeubrutalistButton {
    static func primary(title: String, icon: String? = nil, action: @escaping () -> Void) -> NeubrutalistButton {
        NeubrutalistButton(
            title: title,
            icon: icon,
            backgroundColor: .primaryYellow,
            foregroundColor: .black,
            action: action
        )
    }
    
    static func secondary(title: String, icon: String? = nil, action: @escaping () -> Void) -> NeubrutalistButton {
        NeubrutalistButton(
            title: title,
            icon: icon,
            backgroundColor: .white,
            foregroundColor: .black,
            action: action
        )
    }
    
    static func outline(title: String, icon: String? = nil, action: @escaping () -> Void) -> NeubrutalistButton {
        NeubrutalistButton(
            title: title,
            icon: icon,
            backgroundColor: .clear,
            foregroundColor: .black,
            borderColor: .black,
            shadowColor: .black,
            action: action
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        NeubrutalistButton.primary(title: "Login", icon: "arrow.right") {}
        NeubrutalistButton.secondary(title: "Sign Up") {}
        NeubrutalistButton.outline(title: "Cancel") {}
    }
    .padding()
}
