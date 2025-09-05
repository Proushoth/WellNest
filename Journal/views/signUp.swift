import SwiftUI

struct SignUpPage: View {
    @State private var email = ""
    @State private var password = ""
    
    @State private var errorMessage = ""
    @State private var successMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Create Account")
                .font(.title)
                .fontWeight(.bold)

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
            
            if !successMessage.isEmpty {
                Text(successMessage)
                    .foregroundColor(.green)
            }

            Button(action: signUp) {
                Text("Sign Up")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Sign Up")
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
