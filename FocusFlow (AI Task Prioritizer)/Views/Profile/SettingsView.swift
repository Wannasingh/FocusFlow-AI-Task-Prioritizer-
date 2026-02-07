//
//  SettingsView.swift
//  FocusFlow (AI Task Prioritizer)
//
//  Created by WANNASINGH KHANSOPHON on 26/1/2569 BE.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var notificationsEnabled = true
    @State private var soundEnabled = true
    @State private var darkModeEnabled = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                header
                    .glassBackground(cornerRadius: 20)
                
                // Account Section
                accountSection
                
                // Preferences Section
                preferencesSection
                
                // About Section
                aboutSection
                
                // Logout Button
                logoutButton
                
                Spacer(minLength: 40)
            }
            .padding(.horizontal, 24)
        }
        .background(
            LinearGradient(colors: [Color.black.opacity(0.92), Color.indigo.opacity(0.6), Color.purple.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
    }
    
    // MARK: - Header
    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("SETTINGS")
                .font(.system(size: 36, weight: .black, design: .rounded))
                .foregroundColor(colorScheme == .dark ? .white : .black)
            
            Rectangle()
                .fill(Color.primaryBlue)
                .frame(width: 80, height: 6)
                .overlay(
                    Rectangle()
                        .stroke(Color.black, lineWidth: 2)
                )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 16)
    }
    
    // MARK: - Account Section
    private var accountSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("ACCOUNT")
            
            VStack(spacing: 8) {
                settingRow(icon: "person.fill", title: "Edit Profile", showChevron: true) {}
                settingRow(icon: "envelope.fill", title: "Change Email", showChevron: true) {}
                settingRow(icon: "lock.fill", title: "Change Password", showChevron: true) {}
            }
            .glassBackground(cornerRadius: 16)
        }
    }
    
    // MARK: - Preferences Section
    private var preferencesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("PREFERENCES")
            
            VStack(spacing: 8) {
                toggleRow(icon: "bell.fill", title: "Notifications", isOn: $notificationsEnabled)
                toggleRow(icon: "speaker.wave.2.fill", title: "Sound Effects", isOn: $soundEnabled)
                toggleRow(icon: "moon.fill", title: "Dark Mode", isOn: $darkModeEnabled)
                settingRow(icon: "clock.fill", title: "Focus Timer Settings", showChevron: true) {}
            }
            .glassBackground(cornerRadius: 16)
        }
    }
    
    // MARK: - About Section
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("ABOUT")
            
            VStack(spacing: 8) {
                settingRow(icon: "info.circle.fill", title: "About FocusFlow", showChevron: true) {}
                settingRow(icon: "doc.text.fill", title: "Privacy Policy", showChevron: true) {}
                settingRow(icon: "checkmark.shield.fill", title: "Terms of Service", showChevron: true) {}
                
                HStack {
                    Image(systemName: "app.badge.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                        .frame(width: 40, height: 40)
                    Text("Version")
                        .font(.bodyMedium(16))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    Spacer()
                    Text("1.0.0")
                        .font(.mono(14, weight: .bold))
                        .foregroundColor(.textSecondary)
                }
                .padding(16)
                .glassSubtle(cornerRadius: 12)
            }
            .glassBackground(cornerRadius: 16)
        }
    }
    
    // MARK: - Logout Button
    private var logoutButton: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 18, weight: .semibold))
                Text("Logout")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(18)
            .background(Color.red.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(Color.white.opacity(0.2), lineWidth: 1))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Helper Views
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.displayBold(14))
            .foregroundColor(.textSecondary)
            .tracking(1)
    }
    
    private func settingRow(icon: String, title: String, showChevron: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                    .frame(width: 36, height: 36)
                Text(title)
                    .font(.bodyMedium(16))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                Spacer()
                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(14)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func toggleRow(icon: String, title: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(colorScheme == .dark ? .white : .black)
                .frame(width: 36, height: 36)
            Text(title)
                .font(.bodyMedium(16))
                .foregroundColor(colorScheme == .dark ? .white : .black)
            Spacer()
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(Color.neoCyan)
        }
        .padding(14)
    }
}

#Preview {
    SettingsView()
}
