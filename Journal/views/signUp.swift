import SwiftUI

struct SignUp: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var successMessage = ""
    @State private var navigateToLogin = false
    @FocusState private var focusedField: Field?

    enum Field {
        case email, password
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.blue.opacity(0.1), Color.white],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    VStack(spacing: 8) {
                        Text("Create Account")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text("Join us today")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 60)
                    
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            CustomTextField(
                                placeholder: "Email address",
                                text: $email,
                                isSecure: false
                            )
                            .focused($focusedField, equals: .email)
                            
                            CustomTextField(
                                placeholder: "Password",
                                text: $password,
                                isSecure: true
                            )
                            .focused($focusedField, equals: .password)
                        }
                        .padding(.bottom, 16)
                        
                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .transition(.opacity)
                        }
                        
                        if !successMessage.isEmpty {
                            Text(successMessage)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.green)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .transition(.opacity)
                        }
                        
                        Button(action: signUp) {
                            Text("Create Account")
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
                        .disabled(email.trimmingCharacters(in: .whitespaces).isEmpty || password.isEmpty)
                        .opacity(email.trimmingCharacters(in: .whitespaces).isEmpty || password.isEmpty ? 0.5 : 1.0)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        navigateToLogin = true
                    }) {
                        HStack(spacing: 4) {
                            Text("Already have an account?")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.secondary)
                            
                            Text("Sign in")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 32)
                .navigationBarHidden(true)
                .navigationDestination(isPresented: $navigateToLogin) {
                    LogIn()
                }
                .onAppear {
                    focusedField = .email
                }
            }
        }
    }

    func signUp() {
        errorMessage = ""
        successMessage = ""

        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill all fields"
            return
        }

        let success = UserRepository.signUp(email: email, password: password)
        if success {
            successMessage = "Account created successfully"
            email = ""
            password = ""
        } else {
            errorMessage = "User already exists or error occurred"
        }
    }
}

// MARK: - Custom TextField for Modern UI
struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool
    
    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    SignUp()
}
