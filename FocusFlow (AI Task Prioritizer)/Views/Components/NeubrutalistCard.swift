//
//  NeubrutalistCard.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import SwiftUI

struct NeubrutalistCard<Content: View>: View {
    let backgroundColor: Color
    let borderColor: Color
    let shadowColor: Color
    let content: Content
    
    @State private var isPressed = false
    
    init(
        backgroundColor: Color = .white,
        borderColor: Color = .black,
        shadowColor: Color = .black,
        @ViewBuilder content: () -> Content
    ) {
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.shadowColor = shadowColor
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(backgroundColor)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(borderColor, lineWidth: 3)
            )
            .shadow(color: shadowColor, radius: 0, x: isPressed ? 2 : 4, y: isPressed ? 2 : 4)
            .offset(x: isPressed ? 2 : 0, y: isPressed ? 2 : 0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
    }
    
    func onTapGesture(perform action: @escaping () -> Void) -> some View {
        self.simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in
                    isPressed = false
                    action()
                }
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        NeubrutalistCard(backgroundColor: .neoCyan) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Design System Update")
                    .font(.displayBlack(24))
                Text("High Priority")
                    .font(.bodyBold(12))
            }
        }
        
        NeubrutalistCard(backgroundColor: .neoMagenta) {
            Text("AI Model Training")
                .font(.displayBlack(24))
        }
    }
    .padding()
}
