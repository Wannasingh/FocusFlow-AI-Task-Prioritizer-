//
//  GlassCard.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Liquid Glass card: translucent, rounded, minimal border.
//

import SwiftUI

struct GlassCard<Content: View>: View {
    let content: Content
    var cornerRadius: CGFloat = 20
    
    init(cornerRadius: CGFloat = 20, @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .glassBackground(cornerRadius: cornerRadius)
    }
}

#Preview {
    ZStack {
        LinearGradient(colors: [.neoCyan.opacity(0.3), .neoPurple.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Design System")
                    .font(.headline)
                Text("Liquid Glass card")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
}
