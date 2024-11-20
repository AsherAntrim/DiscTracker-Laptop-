import SwiftUI
import FirebaseAuth

struct AuthView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSignUp: Bool = false
    @State private var errorMessage: String = ""

    // Updated theme colors for DiscTracker
    let primaryColor = Color(red: 34/255, green: 139/255, blue: 34/255) // Green
    let accentColor = Color(red: 255/255, green: 140/255, blue: 0/255) // Orange

    var body: some View {
        ZStack {
            // Primary background
            primaryColor
                .edgesIgnoringSafeArea(.all) // Ensures the background covers the entire screen

            VStack(spacing: 20) {
                Spacer() // Push content towards the center

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

                // Toggle between Sign Up and Sign In
                Button(action: {
                    isSignUp.toggle()
                }) {
                    Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                        .font(.footnote)
                        .foregroundColor(.white)
                }

                // Resend email verification
                if !isSignUp {
                    Button(action: {
                        sendEmailVerification()
                    }) {
                        Text("Resend Verification Email")
                            .font(.footnote)
                            .foregroundColor(.white)
                            .underline()
                    }
                }

                Spacer() // Push content towards the center
            }
            .padding() // Adds padding to the content
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
            } else {
                errorMessage = ""
                sendEmailVerification()
            }
        }
    }

    private func sendEmailVerification() {
        if let user = Auth.auth().currentUser {
            user.sendEmailVerification { error in
                if let error = error {
                    errorMessage = "Failed to send verification email: \(error.localizedDescription)"
                } else {
                    errorMessage = "Verification email sent. Please check your inbox."
                }
            }
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
