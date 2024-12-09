//
//  AuthView.swift
//  DiscTracker
//
//  Created by Asher Antrim
//  Modified by OpenAI on 12/09/24.
//

import SwiftUI
import FirebaseAuth

struct AuthView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSignUp: Bool = false
    @State private var errorMessage: String = ""

    var body: some View {
        ZStack {
            Theme.backgroundColor.edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Spacer()

                Text(isSignUp ? "Create an Account" : "Welcome Back")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.primaryTextColor)

                CustomTextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .cornerRadius(10)
                    .shadow(radius: 5)

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
