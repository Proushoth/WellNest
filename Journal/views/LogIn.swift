import SwiftUI

struct LoginPage: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var isLoggedIn = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("🌿 Wellness Journal")
                    .font(.title)
                    .fontWeight(.bold)
                Text("\"Your mindful journey starts here\"")
                    .foregroundColor(.gray)

                TextField("Email / Username", text: $email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                Button("Log In") {
                    loginUser()
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)

                Divider().padding(.vertical)

                Button("Continue with Apple") { }
                Button("Continue with Google") { }

                // 👉 Navigation to SignUpPage
                HStack {
                    Text("Don’t have an account?")
                    NavigationLink("Sign Up") {
                        SignUpPage()
                    }
                    .foregroundColor(.blue)
                }

                // Navigate to Home page on success
                NavigationLink(destination: profilePage(), isActive: $isLoggedIn) {
                    EmptyView()
                }

                Spacer()
            }
            .padding()
        }
    }

    func loginUser() {
        errorMessage = ""
        
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill all fields"
            return
        }
        
        let success = UserRepository.login(email: email, password: password)
        if success {
            isLoggedIn = true
        } else {
            errorMessage = "Invalid email or password"
        }
    }
}


#Preview {
    LoginPage()
}
