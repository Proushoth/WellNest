import SwiftUI
import LocalAuthentication

struct LogIn: View {

    @State private var email = ""
    @State private var password = ""
    @State private var isAuthenticated = false
    @State private var showError = false
    @State private var showForgotPassword = false
    @FocusState private var focusedField: Field?

    enum Field {
        case email, password
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGroupedBackground).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    VStack(spacing: 8) {
                        Text("Welcome")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text("Sign in to continue")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 60)
                    
                    VStack(spacing: 20) {
                        // Email Field
                        TextField("Email address", text: $email)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            )
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .focused($focusedField, equals: .email)
                        
                        // Password Field
                        SecureField("Password", text: $password)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            )
                            .focused($focusedField, equals: .password)
                        
                        // Sign In Button
                        Button(action: {
                            Task {
                                await authenticateUser()
                            }
                        }) {
                            Text("Sign in")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.blue)
                                        .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                                )
                        }
                        
                        // Forgot Password Button
                        Button(action: {
                            showForgotPassword = true
                        }) {
                            Text("Forgot Password?")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        
                        // Face ID Button
                        Button(action: {}) {
                            HStack(spacing: 12) {
                                Image(systemName: "faceid")
                                    .font(.system(size: 18, weight: .regular))
                                Text("Use Face ID")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal, 0)
                    
                    Spacer()
                    
                    // Sign Up Navigation
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.secondary)
                        
                        NavigationLink("Sign up", destination: SignUp())
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.blue)
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
                .onAppear {
                    focusedField = .email
                }
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
