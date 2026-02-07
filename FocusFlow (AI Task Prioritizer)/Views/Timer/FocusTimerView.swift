//
//  FocusTimerView.swift
//  FocusFlow (AI Task Prioritizer)
//

import SwiftUI

struct FocusTimerView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                HStack {
                    Button(action: {}) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                            .frame(width: 40, height: 40)
                            .glassBar(cornerRadius: 12)
                    }
                    Spacer()
                    Text("Focus Timer")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                            .frame(width: 40, height: 40)
                            .glassBar(cornerRadius: 12)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                Spacer(minLength: 40)
                
                VStack(spacing: 16) {
                    Text("Focus Timer")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    Text("พร้อมเพิ่มฟีเจอร์ Timer ได้ที่นี่")
                        .font(.bodyMedium(14))
                        .foregroundColor(.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 60)
                .glassBackground(cornerRadius: 24)
                .padding(.horizontal, 24)
                
                Spacer(minLength: 80)
            }
        }
        .background(colorScheme == .dark ? Color.backgroundDarkAlt : Color.backgroundLight)
    }
}

#Preview {
    FocusTimerView()
}
