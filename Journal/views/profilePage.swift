//
//  profilePage.swift
//  Journal
//
//  Created by Proushoth Koushal on 8/19/25.
//

import SwiftUI

struct profilePage: View {
    @State private var userName = "John Doe"
    @State private var email = "john@example.com"
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    @State private var isLoggedOut = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("User Info")) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(userName)
                                .font(.headline)
                            Text(email)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
                
                Section(header: Text("Preferences")) {
                    Toggle(isOn: $notificationsEnabled) {
                        Label("Notifications", systemImage: "bell.fill")
                    }
                    Toggle(isOn: $darkModeEnabled) {
                        Label("Dark Mode", systemImage: "moon.fill")
                    }
                }
                
                Section {
                    NavigationLink {
                        Text("Change Password View")
                    } label: {
                        Label("Change Password", systemImage: "key.fill")
                    }
                }
                
                Section {
                    Button(role: .destructive, action: logOut) {
                        Label("Log Out", systemImage: "arrow.backward.circle.fill")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $isLoggedOut) {
                LogIn()
            }
        }
    }
    
    private func logOut() {
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        isLoggedOut = true
    }
}

#Preview {
    profilePage()
}
