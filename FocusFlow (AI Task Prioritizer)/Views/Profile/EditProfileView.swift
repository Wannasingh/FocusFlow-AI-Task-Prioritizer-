//
//  EditProfileView.swift
//  FocusFlow (AI Task Prioritizer)
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authService: AuthService
    @Environment(\.colorScheme) var colorScheme
    
    @State private var displayName: String = ""
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    private var user: Models.User? { authService.currentUser }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // รูปโปรไฟล์ – เลือกจากเครื่องแล้วอัปโหลดไป Supabase bucket "avatars"
                    VStack(spacing: 12) {
                        avatarPreview
                        Button(action: { showImagePicker = true }) {
                            HStack(spacing: 8) {
                                Image(systemName: "photo.badge.plus")
                                Text("CHANGE PHOTO")
                                    .font(.displayBold(12))
                            }
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(Color.neoYellow)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                        }
                    }
                    .padding(.bottom, 8)
                    
                    NeubrutalistTextField(
                        label: "Display Name",
                        icon: "person.fill",
                        placeholder: "Your name",
                        text: $displayName
                    )
                    
                    // Email แสดงอย่างเดียว (แก้ที่ Auth ไม่ได้จาก profile)
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "envelope.fill")
                                .font(.system(size: 18, weight: .bold))
                            Text("EMAIL")
                                .font(.displayBold(14))
                                .textCase(.uppercase)
                                .tracking(1.2)
                        }
                        .foregroundColor(colorScheme == .dark ? .white : .textPrimary)
                        
                        Text(user?.email ?? "")
                            .font(.bodyMedium(16))
                            .foregroundColor(.textSecondary)
                            .padding(.horizontal, 16)
                            .frame(height: 56)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(colorScheme == .dark ? Color(hex: "#1a1a1a") : Color.gray.opacity(0.15))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(colorScheme == .dark ? Color.gray : Color.black.opacity(0.3), lineWidth: 2)
                            )
                    }
                    
                    if let msg = errorMessage {
                        Text(msg)
                            .font(.bodyMedium(14))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Button(action: saveProfile) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                            } else {
                                Text("SAVE CHANGES")
                                    .font(.displayBold(14))
                            }
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.neoLime)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.black, lineWidth: 2)
                        )
                        .shadow(color: .black, radius: 0, x: 3, y: 3)
                    }
                    .disabled(isLoading || displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .padding(.top, 8)
                }
                .padding(24)
            }
            .background(colorScheme == .dark ? Color.backgroundDarkAlt : Color.backgroundLight)
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.bodyBold(14))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage)
            }
            .onAppear {
                displayName = user?.displayName ?? ""
            }
        }
    }
    
    private var avatarPreview: some View {
        Group {
            if let img = selectedImage {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
            } else if let urlString = user?.avatarURL, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .failure(_):
                        avatarPlaceholder
                    case .empty:
                        ProgressView()
                    @unknown default:
                        avatarPlaceholder
                    }
                }
                .frame(width: 120, height: 120)
                .clipShape(Circle())
            } else {
                avatarPlaceholder
            }
        }
        .frame(width: 120, height: 120)
        .overlay(Circle().stroke(Color.black, lineWidth: 4))
        .shadow(color: .black, radius: 0, x: 4, y: 4)
    }
    
    private var avatarPlaceholder: some View {
        Circle()
            .fill(Color.neoYellow)
            .overlay(
                Text(avatarInitials)
                    .font(.system(size: 44, weight: .black, design: .rounded))
                    .foregroundColor(.black)
            )
    }
    
    private var avatarInitials: String {
        let name = displayName.isEmpty ? (user?.displayName ?? "") : displayName
        let parts = name.split(separator: " ").map(String.init)
        if parts.count >= 2, let f = parts.first?.first, let s = parts.last?.first {
            return "\(f)\(s)".uppercased()
        }
        let prefix = String(name.prefix(2)).uppercased()
        return prefix.isEmpty ? "?" : prefix
    }
    
    private func saveProfile() {
        errorMessage = nil
        isLoading = true
        Task {
            do {
                var finalAvatarURL: String? = user?.avatarURL
                if let image = selectedImage,
                   let jpegData = image.jpegData(compressionQuality: 0.8) {
                    let url = try await authService.uploadAvatar(imageData: jpegData)
                    finalAvatarURL = url
                }
                try await authService.updateProfile(
                    displayName: displayName,
                    avatarURL: finalAvatarURL
                )
                dismiss()
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}

#Preview {
    EditProfileView()
        .environmentObject(AuthService())
}
