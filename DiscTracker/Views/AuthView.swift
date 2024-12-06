import SwiftUI
import FirebaseAuth

struct CustomSecureField: View {
    var placeholder: String
    @Binding var text: String

    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }

    var body: some View {
        SecureField(placeholder, text: $text)
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.secondarySystemBackground))
            )
            .foregroundColor(.primary)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct AuthView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSignUp: Bool = false
    @State private var errorMessage: String = ""

    var body: some View {
        ZStack {
            // Primary background
            Theme.backgroundColor
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Spacer()

                // Heading
                Text(isSignUp ? "Create an Account" : "Welcome Back")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.primaryTextColor)

                // Email input
                CustomTextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .cornerRadius(10)
                    .shadow(radius: 5)

                // Password input
                CustomSecureField("Password", text: $password)
                    .padding()
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
                        .background(Theme.highlightColor)
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
                        .foregroundColor(Theme.primaryTextColor)
                }
                Spacer()
            }
            .padding()
        }
    }

    private func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
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
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                // Send email verification
                Auth.auth().currentUser?.sendEmailVerification { error in
                    if let error = error {
                        errorMessage = error.localizedDescription
                    } else {
                        errorMessage = "Verification email sent. Please check your inbox."
                    }
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
