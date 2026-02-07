//
//  GlassButton.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Liquid Glass button: translucent capsule/pill with optional accent.
//

import SwiftUI

struct GlassButton: View {
    let title: String
    let icon: String?
    let style: GlassButtonStyle
    let action: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    
    enum GlassButtonStyle {
        case primary   // filled accent, solid text
        case secondary // glass only
        case destructive
    }
    
    init(
        _ title: String,
        icon: String? = nil,
        style: GlassButtonStyle = .primary,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.action = action
    }
    
    private var accentColor: Color {
        switch style {
        case .primary: return .neoCyan
        case .secondary: return colorScheme == .dark ? .white : .black
        case .destructive: return .red
        }
    }
    
    private var isFilled: Bool {
        style == .primary || style == .destructive
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                }
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(style == .primary || style == .destructive ? .black : accentColor)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background {
                if isFilled {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(accentColor.opacity(style == .destructive ? 0.9 : 1))
                } else {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(.ultraThinMaterial)
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(.white.opacity(isFilled ? 0.4 : 0.25), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ZStack {
        Color.backgroundLight.ignoresSafeArea()
        VStack(spacing: 16) {
            GlassButton("Continue", icon: "arrow.right", style: .primary) {}
            GlassButton("Cancel", style: .secondary) {}
            GlassButton("Delete", icon: "trash", style: .destructive) {}
        }
        .padding()
    }
}
