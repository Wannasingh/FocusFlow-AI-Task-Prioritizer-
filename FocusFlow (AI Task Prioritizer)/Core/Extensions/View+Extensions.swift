//
//  View+Extensions.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import SwiftUI

extension View {
    // MARK: - Neubrutalism Shadows
    func neuShadow(color: Color = .black, x: CGFloat = 4, y: CGFloat = 4) -> some View {
        self.shadow(color: color, radius: 0, x: x, y: y)
    }
    
    func neuShadowSmall(color: Color = .black) -> some View {
        self.shadow(color: color, radius: 0, x: 2, y: 2)
    }
    
    func neuShadowLarge(color: Color = .black) -> some View {
        self.shadow(color: color, radius: 0, x: 6, y: 6)
    }
    
    // MARK: - Neubrutalism Border
    func neuBorder(color: Color = .black, width: CGFloat = 3) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(color, lineWidth: width)
        )
    }
    
    func neuBorderCircle(color: Color = .black, width: CGFloat = 3) -> some View {
        self.overlay(
            Circle()
                .stroke(color, lineWidth: width)
        )
    }
    
    // MARK: - Neubrutalism Card Style
    func neuCard(backgroundColor: Color, borderColor: Color = .black, shadowColor: Color = .black) -> some View {
        self
            .background(backgroundColor)
            .cornerRadius(12)
            .neuBorder(color: borderColor)
            .neuShadow(color: shadowColor)
    }
    
    // MARK: - Active Press Effect
    func neuPressEffect() -> some View {
        self.modifier(NeubrutalistPressEffect())
    }
}

// MARK: - Press Effect Modifier
struct NeubrutalistPressEffect: ViewModifier {
    @State private var isPressed = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .offset(x: isPressed ? 2 : 0, y: isPressed ? 2 : 0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in isPressed = true }
                    .onEnded { _ in isPressed = false }
            )
    }
}

// MARK: - Conditional Modifier
extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
