import SwiftUI

struct SignUpPage: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var successMessage = ""
    @FocusState private var focusedField: Field?

    enum Field {
        case email, password
    }

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.2)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack(spacing: 28) {
                Spacer()
                VStack(spacing: 16) {
                    Text("Create Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.bottom, 8)

                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.blue)
                            TextField("Email / Username", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .focused($focusedField, equals: .email)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(14)
                        .shadow(color: .blue.opacity(0.08), radius: 4, x: 0, y: 2)

                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.purple)
                            SecureField("Password", text: $password)
                                .focused($focusedField, equals: .password)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(14)
                        .shadow(color: .purple.opacity(0.08), radius: 4, x: 0, y: 2)
                    }
                }

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .padding(.horizontal)
                        .transition(.opacity)
                }

                if !successMessage.isEmpty {
                    Text(successMessage)
                        .foregroundColor(.green)
                        .font(.subheadline)
                        .padding(.horizontal)
                        .transition(.opacity)
                }

                Button(action: signUp) {
                    HStack {
                        Spacer()
                        Text("Sign Up")
                            .font(.headline)
                            .padding()
                        Spacer()
                    }
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(14)
                    .shadow(radius: 4)
                }
                .disabled(email.trimmingCharacters(in: .whitespaces).isEmpty || password.isEmpty)
                .opacity(email.trimmingCharacters(in: .whitespaces).isEmpty || password.isEmpty ? 0.6 : 1)

                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 40)
        }
        .navigationTitle("Sign Up")
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
            successMessage = "Sign-up successful!"
            email = ""
            password = ""
        } else {
            errorMessage = "User already exists or error occurred"
        }
    }
}

#Preview {
    SignUpPage()
}
