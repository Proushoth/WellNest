import SwiftUI

struct SignUp: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var successMessage = ""
    @FocusState private var focusedField: Field?

    enum Field {
        case email, password
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 8) {
                Text("Create account")
                    .font(.system(size: 32, weight: .light, design: .default))
                    .foregroundStyle(.primary)
                
                Text("Join us today")
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
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .focused($focusedField, equals: .email)
                    
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
                        .focused($focusedField, equals: .password)
                }
                .padding(.bottom, 24)
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .transition(.opacity)
                        .padding(.bottom, 8)
                }
                
                if !successMessage.isEmpty {
                    Text(successMessage)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.green)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .transition(.opacity)
                        .padding(.bottom, 8)
                }
                
                Button(action: signUp) {
                    Text("Create account")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .disabled(email.trimmingCharacters(in: .whitespaces).isEmpty || password.isEmpty)
                .opacity(email.trimmingCharacters(in: .whitespaces).isEmpty || password.isEmpty ? 0.4 : 1.0)
            }
            
            Spacer()
            
            HStack(spacing: 4) {
                Text("Already have an account?")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(.secondary)
                
                Button("Sign in") {
                    
                }
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.primary)
            }
            .padding(.bottom, 40)
        }
        .padding(.horizontal, 32)
        .navigationBarHidden(true)
        .onAppear {
            focusedField = .email
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

#Preview {
    SignUp()
}
