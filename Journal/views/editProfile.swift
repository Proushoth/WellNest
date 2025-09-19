//
//  editProfile.swift
//  Journal
//
//  Created by proushoth koushal on 9/19/25.
//

import SwiftUI

struct editProfile: View {
    @Environment(\.dismiss) private var dismiss
    @State private var username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // This would come from your user data
    private let userEmail = "user@example.com"
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Profile Information")) {
                    TextField("Username", text: $username)
                        .textContentType(.username)
                    
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(userEmail)
                            .foregroundColor(.gray)
                    }
                }
                
                Section(header: Text("Change Password")) {
                    SecureField("Current Password", text: $currentPassword)
                        .textContentType(.password)
                    
                    SecureField("New Password", text: $newPassword)
                        .textContentType(.newPassword)
                    
                    SecureField("Confirm New Password", text: $confirmPassword)
                        .textContentType(.newPassword)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChanges()
                    }
                }
            }
            .alert("Profile Update", isPresented: $showAlert) {
                Button("OK") {
                    if alertMessage == "Profile updated successfully" {
                        dismiss()
                    }
                }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func saveChanges() {
        // Validate username
        guard !username.isEmpty else {
            alertMessage = "Username cannot be empty"
            showAlert = true
            return
        }
        
        // If password fields are filled, validate password change
        if !currentPassword.isEmpty || !newPassword.isEmpty || !confirmPassword.isEmpty {
            guard !currentPassword.isEmpty else {
                alertMessage = "Please enter your current password"
                showAlert = true
                return
            }
            
            guard !newPassword.isEmpty else {
                alertMessage = "Please enter a new password"
                showAlert = true
                return
            }
            
            guard newPassword == confirmPassword else {
                alertMessage = "New passwords don't match"
                showAlert = true
                return
            }
            
            guard newPassword.count >= 6 else {
                alertMessage = "New password must be at least 6 characters"
                showAlert = true
                return
            }
            
            // Here you would verify the current password and update with new password
            // Implementation depends on your authentication system
        }
        
        // Save username to UserDefaults (replace with your data persistence method)
        UserDefaults.standard.set(username, forKey: "username")
        
        // Show success message
        alertMessage = "Profile updated successfully"
        showAlert = true
    }
}

#Preview {
    editProfile()
}
