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
                                    .font(.system(size: 14, weight: .semibold))
                                Text("Change photo")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .glassBar(cornerRadius: 12)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.bottom, 8)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "person.fill").font(.system(size: 16, weight: .semibold))
                            Text("Display Name").font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundStyle(.white.opacity(0.9))
                        TextField("Your name", text: $displayName)
                            .font(.system(size: 16))
                            .padding(.horizontal, 16)
                            .frame(height: 52)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(.white.opacity(0.25), lineWidth: 1))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "envelope.fill")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Email")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.secondary)
                        }
                        .foregroundColor(colorScheme == .dark ? .white : .textPrimary)
                        Text(user?.email ?? "")
                            .font(.bodyMedium(16))
                            .foregroundColor(.textSecondary)
                            .padding(.horizontal, 16)
                            .frame(height: 52)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .glassSubtle(cornerRadius: 12)
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
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Save changes")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.neoCyan)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(.white.opacity(0.3), lineWidth: 1))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(isLoading || displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .padding(.top, 8)
                }
                .padding(24)
            }
            .background(
                LinearGradient(colors: [Color.black.opacity(0.92), Color.indigo.opacity(0.6), Color.purple.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
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
    
    private static let avatarSize: CGFloat = 120
    private static let avatarCornerRadius: CGFloat = 24
    
    private var avatarPreview: some View {
        Group {
            if let img = selectedImage {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
                    .frame(width: Self.avatarSize, height: Self.avatarSize)
                    .clipShape(RoundedRectangle(cornerRadius: Self.avatarCornerRadius))
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
                .frame(width: Self.avatarSize, height: Self.avatarSize)
                .clipShape(RoundedRectangle(cornerRadius: Self.avatarCornerRadius))
            } else {
                avatarPlaceholder
            }
        }
        .frame(width: Self.avatarSize, height: Self.avatarSize)
        .overlay(RoundedRectangle(cornerRadius: Self.avatarCornerRadius).strokeBorder(.white.opacity(0.4), lineWidth: 1))
    }
    
    private var avatarPlaceholder: some View {
        RoundedRectangle(cornerRadius: Self.avatarCornerRadius)
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
    
    /// ลดขนาดรูปก่อนอัปโหลด ให้ตอบสนองเร็วขึ้น
    private func resizedAvatarData(from image: UIImage, maxSide: CGFloat = 512, quality: CGFloat = 0.65) -> Data? {
        let scale = min(maxSide / image.size.width, maxSide / image.size.height, 1)
        guard scale < 1 else { return image.jpegData(compressionQuality: quality) }
        let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 1)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resized?.jpegData(compressionQuality: quality)
    }
    
    private func saveProfile() {
        errorMessage = nil
        isLoading = true
        Task {
            var finalAvatarURL: String? = user?.avatarURL
            var uploadFailedMessage: String?
            if let image = selectedImage,
               let jpegData = resizedAvatarData(from: image) {
                do {
                    let url = try await authService.uploadAvatar(imageData: jpegData)
                    finalAvatarURL = url
                } catch {
                    uploadFailedMessage = "Photo: \(error.localizedDescription)"
                }
            }
            do {
                try await authService.updateProfile(
                    displayName: displayName,
                    avatarURL: finalAvatarURL
                )
                if let msg = uploadFailedMessage {
                    errorMessage = "Profile saved. \(msg)"
                } else {
                    dismiss()
                }
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
