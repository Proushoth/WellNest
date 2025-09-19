import SwiftUI
import LocalAuthentication

struct LogIn: View {

    @State private var email = ""
    @State private var password = ""
    @State private var isAuthenticated = false
    @State private var showError = false
    @State private var showForgotPassword = false 

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Spacer()
                
                VStack(spacing: 8) {
                    Text("Welcome")
                        .font(.system(size: 32, weight: .light, design: .default))
                        .foregroundStyle(.primary)
                    
                    Text("Sign in to continue")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(.secondary)
                }
                .padding(.bottom, 60)
                
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
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
                        
                        SecureField("Password", text: $password)
                            .font(.system(size: 16, weight: .regular))
                            .padding(.vertical, 16)
                            .padding(.horizontal, 0)
                            .background(Color.clear)
                            .overlay(
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundStyle(password.isEmpty ? .tertiary : .primary)
                                    .animation(.easeInOut(duration: 0.2), value: password.isEmpty),
                                alignment: .bottom
                            )
                    }
                    .padding(.bottom, 24)
                    
                    Button(action: {
                        Task {
                            await authenticateUser()
                        }
                    }) {
                        Text("Sign in")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    Button(action: {
                        // Navigate to Forgot Password
                        showForgotPassword = true
                    }) {
                        Text("Forgot Password?")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.blue)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    
                    Button(action: {
                        // Face ID Authentication (optional)
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "faceid")
                                .font(.system(size: 18, weight: .regular))
                            Text("Use Face ID")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.quaternary, lineWidth: 1)
                        )
                    }
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text("Don't have an account?")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(.secondary)
                    
                    NavigationLink("Sign up", destination: SignUp())
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.primary)
                }
                .padding(.bottom, 40)
            }
            .padding(.horizontal, 32)
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $isAuthenticated) {
                ContentView()
            }
            .navigationDestination(isPresented: $showForgotPassword) {
                forgetPassword()
            }
            .alert("Authentication failed", isPresented: $showError) {
                Button("Try again", role: .cancel) { }
            } message: {
                Text("Please check your credentials and try again.")
            }
        }
    }
    
    private func authenticateUser() async {
        if UserRepository.login(email: email, password: password) {
            isAuthenticated = true
        } else {
            showError = true
        }
    }
}

#Preview {
    LogIn()
}
