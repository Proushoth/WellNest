//
//  profilePage.swift
//  Journal
//
//  Created by proushoth koushal on 8/19/25.
//

import SwiftUI

struct profilePage: View {
    @State private var userName = "John Doe"
    @State private var email = "john@example.com"
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    VStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                        
                        Text(userName)
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text(email)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial)
                    .cornerRadius(18)
                    
                    // Statistics
                    HStack(spacing: 20) {
                        ProfileStatCard(title: "Goals", value: "12", color: .blue)
                        ProfileStatCard(title: "Habits", value: "8", color: .green)
                        ProfileStatCard(title: "Journals", value: "24", color: .purple)
                    }
                    
                    // Settings
                    VStack(spacing: 8) {
                        SettingsRow(title: "Notifications", icon: "bell.fill", isEnabled: $notificationsEnabled)
                        Divider()
                        SettingsRow(title: "Dark Mode", icon: "moon.fill", isEnabled: $darkModeEnabled)
                        Divider()
                        NavigationLink {
                            Text("Edit Profile View") // Replace with your edit profile view
                        } label: {
                            SettingsLinkRow(title: "Edit Profile", icon: "person.fill")
                        }
                        Divider()
                        NavigationLink {
                            Text("Privacy Policy View") // Replace with your privacy policy view
                        } label: {
                            SettingsLinkRow(title: "Privacy Policy", icon: "lock.fill")
                        }
                        Divider()
                        NavigationLink {
                            Text("Help & Support View") // Replace with your help view
                        } label: {
                            SettingsLinkRow(title: "Help & Support", icon: "questionmark.circle.fill")
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(18)
                    
                    Button(action: {
                        // Handle logout
                    }) {
                        Text("Log Out")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(gradient: Gradient(colors: [.red.opacity(0.8), .red]), startPoint: .leading, endPoint: .trailing)
                            )
                            .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle("Profile")
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.1), Color.blue.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
            )
        }
    }
}

struct ProfileStatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    @Binding var isEnabled: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            Text(title)
            Spacer()
            Toggle("", isOn: $isEnabled)
        }
        .padding(.vertical, 8)
    }
}

struct SettingsLinkRow: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            Text(title)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    profilePage()
}




