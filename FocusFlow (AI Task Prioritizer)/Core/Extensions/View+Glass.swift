//
//  View+Glass.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Apple Liquid Glass จริง (iOS 26+): ใช้ glassEffect()
//  Fallback (iOS < 26): ใช้ Material
//

import SwiftUI

// MARK: - Liquid Glass จริง (iOS 26) + Fallback
extension View {
    /// การ์ด/บล็อก – Liquid Glass จริงบน iOS 26, Material บนเวอร์ชันเก่า
    @ViewBuilder
    func glassBackground(cornerRadius: CGFloat = 20) -> some View {
        if #available(iOS 26, *) {
            self
                .glassEffect(in: .rect(cornerRadius: cornerRadius))
        } else {
            self
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
                )
        }
    }

    /// แถบ/ปุ่ม – Liquid Glass จริงหรือ thinMaterial
    @ViewBuilder
    func glassBar(cornerRadius: CGFloat = 16) -> some View {
        if #available(iOS 26, *) {
            self
                .glassEffect(in: .rect(cornerRadius: cornerRadius))
        } else {
            self
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
                )
        }
    }

    /// Section ย่อย
    @ViewBuilder
    func glassSubtle(cornerRadius: CGFloat = 12) -> some View {
        if #available(iOS 26, *) {
            self
                .glassEffect(in: .rect(cornerRadius: cornerRadius))
        } else {
            self
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: cornerRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(Color.primary.opacity(0.06), lineWidth: 1)
                )
        }
    }
}

// MARK: - Neumorphism เบา (เมื่อไม่ใช้ glass)
extension View {
    func neuSoft(cornerRadius: CGFloat = 12) -> some View {
        self
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(Color.primary.opacity(0.06), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.04), radius: 4, x: 2, y: 2)
            .shadow(color: .white.opacity(0.6), radius: 4, x: -1, y: -1)
    }
}
