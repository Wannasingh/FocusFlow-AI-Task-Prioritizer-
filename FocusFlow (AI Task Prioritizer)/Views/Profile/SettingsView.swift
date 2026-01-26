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
        .background(colorScheme == .dark ? Color.backgroundDarkAlt : Color.backgroundLight)
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
            
            VStack(spacing: 12) {
                settingRow(icon: "person.fill", title: "Edit Profile", showChevron: true) {}
                settingRow(icon: "envelope.fill", title: "Change Email", showChevron: true) {}
                settingRow(icon: "lock.fill", title: "Change Password", showChevron: true) {}
            }
        }
    }
    
    // MARK: - Preferences Section
    private var preferencesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("PREFERENCES")
            
            VStack(spacing: 12) {
                toggleRow(icon: "bell.fill", title: "Notifications", isOn: $notificationsEnabled)
                toggleRow(icon: "speaker.wave.2.fill", title: "Sound Effects", isOn: $soundEnabled)
                toggleRow(icon: "moon.fill", title: "Dark Mode", isOn: $darkModeEnabled)
                settingRow(icon: "clock.fill", title: "Focus Timer Settings", showChevron: true) {}
            }
        }
    }
    
    // MARK: - About Section
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("ABOUT")
            
            VStack(spacing: 12) {
                settingRow(icon: "info.circle.fill", title: "About FocusFlow", showChevron: true) {}
                settingRow(icon: "doc.text.fill", title: "Privacy Policy", showChevron: true) {}
                settingRow(icon: "checkmark.shield.fill", title: "Terms of Service", showChevron: true) {}
                
                // Version
                HStack {
                    Image(systemName: "app.badge.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
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
                .background(colorScheme == .dark ? Color.backgroundDarkDeep : Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 2)
                )
            }
        }
    }
    
    // MARK: - Logout Button
    private var logoutButton: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 20, weight: .bold))
                
                Text("LOGOUT")
                    .font(.displayBold(16))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(Color.red)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.black, lineWidth: 3)
            )
            .shadow(color: .black, radius: 0, x: 4, y: 4)
        }
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
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .frame(width: 40, height: 40)
                
                Text(title)
                    .font(.bodyMedium(16))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
                Spacer()
                
                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.textSecondary)
                }
            }
            .padding(16)
            .background(colorScheme == .dark ? Color.backgroundDarkDeep : Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 2)
            )
        }
    }
    
    private func toggleRow(icon: String, title: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .frame(width: 40, height: 40)
            
            Text(title)
                .font(.bodyMedium(16))
                .foregroundColor(colorScheme == .dark ? .white : .black)
            
            Spacer()
            
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(Color.primaryGreen)
        }
        .padding(16)
        .background(colorScheme == .dark ? Color.backgroundDarkDeep : Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 2)
        )
    }
}

#Preview {
    SettingsView()
}
