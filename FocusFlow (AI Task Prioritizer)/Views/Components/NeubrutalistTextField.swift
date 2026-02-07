//
//  NeubrutalistTextField.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import SwiftUI

struct NeubrutalistTextField: View {
    let label: String
    let icon: String?
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    @FocusState private var isFocused: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Label
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .bold))
                }
                Text(label)
                    .font(.displayBold(14))
                    .textCase(.uppercase)
                    .tracking(1.2)
            }
            .foregroundColor(colorScheme == .dark ? .white : .textPrimary)
            
            // Text Field
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .focused($isFocused)
                } else {
                    TextField(placeholder, text: $text)
                        .focused($isFocused)
                }
            }
            .font(.bodyMedium(16))
            .padding(.horizontal, 16)
            .frame(height: 52)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            .foregroundColor(colorScheme == .dark ? .white : .textPrimary)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(.white.opacity(isFocused ? 0.4 : 0.2), lineWidth: 1)
            )
            .animation(.easeInOut(duration: 0.15), value: isFocused)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        NeubrutalistTextField(
            label: "Email",
            icon: "envelope",
            placeholder: "name@example.com",
            text: .constant("")
        )
        
        NeubrutalistTextField(
            label: "Password",
            icon: "lock",
            placeholder: "••••••••",
            text: .constant(""),
            isSecure: true
        )
    }
    .padding()
    .background(Color.backgroundLight)
}
