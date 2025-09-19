//
//  forgetPassword.swift
//  Journal
//
//  Created by proushoth koushal on 9/18/25.
//

import SwiftUI

struct forgetPassword: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var showSuccess = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Reset Password")
                    .font(.system(size: 32, weight: .light))
                    .padding(.top, 40)
                
                Text("Enter your email address and we'll send you a link to reset your password.")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                TextField("Email address", text: $email)
                    .font(.system(size: 16, weight: .regular))
                    .padding(.vertical, 16)
                    .padding(.horizontal, 0)
                    .background(Color.clear)
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(email.isEmpty ? .tertiary : .primary)
                            .animation(.easeInOut(duration: 0.2), value: email.isEmpty),
                        alignment: .bottom
                    )
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .padding(.top, 32)
                
                Button(action: resetPassword) {
                    Text("Send Reset Link")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                Spacer()
            }
            .padding(.horizontal, 32)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.left")
                            .foregroundStyle(.primary)
                    }
                }
            }
            .alert("Reset Link Sent", isPresented: $showSuccess) {
                Button("OK") { dismiss() }
            } message: {
                Text("Please check your email for instructions to reset your password.")
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage.isEmpty ? "Could not send reset link. Please try again." : errorMessage)
            }
        }
    }
    
    private func resetPassword() {
        guard !email.isEmpty else {
            errorMessage = "Please enter your email address."
            showError = true
            return
        }
        
        guard let url = URL(string: "http://localhost:3000/api/forgot-password") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["email": email]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = error.localizedDescription
                    showError = true
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    errorMessage = "No response from server."
                    showError = true
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(ForgotPasswordResponse.self, from: data)
                DispatchQueue.main.async {
                    if result.success {
                        showSuccess = true
                    } else {
                        errorMessage = result.message
                        showError = true
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    errorMessage = "Failed to parse response."
                    showError = true
                }
            }
        }.resume()
    }
}

struct ForgotPasswordResponse: Codable {
    let success: Bool
    let message: String
}

#Preview {
    forgetPassword()
}
