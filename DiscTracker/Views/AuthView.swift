import SwiftUI
import FirebaseAuth

struct AuthView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSignUp: Bool = false
    @State private var errorMessage: String = ""

    // Updated theme colors for DiscTracker
    let primaryColor = Color(red: 34/255, green: 139/255, blue: 34/255)
    let accentColor = Color(red: 255/255, green: 140/255, blue: 0/255)

    var body: some View {
        ZStack {
            // Primary background
            primaryColor
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Spacer()

                // Heading
                Text(isSignUp ? "Create an Account" : "Welcome Back")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                // Email input
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .shadow(radius: 5)

                // Password input
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .shadow(radius: 5)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding()
                        .multilineTextAlignment(.center)
                }

                // Sign In / Sign Up button
                Button(action: {
                    isSignUp ? signUp() : signIn()
                }) {
                    Text(isSignUp ? "Sign Up" : "Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(accentColor)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)

                // Toggle between Sign In and Sign Up
                Button(action: {
                    isSignUp.toggle()
                }) {
                    Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                        .font(.footnote)
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .padding()
        }
    }

    private func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                if let user = Auth.auth().currentUser, !user.isEmailVerified {
                    errorMessage = "Please verify your email address."
                } else {
                    errorMessage = ""
                    print("Signed in successfully!")
                }
            }
        }
    }

    private func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
            }
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
