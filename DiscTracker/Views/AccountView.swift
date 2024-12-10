//
//  AccountView.swift
//  DiscTracker
//
//  Created by Asher Antrim on 11/20/24.
//  Modified by OpenAI on 12/09/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct AccountView: View {
    @StateObject var userDiscViewModel: UserDiscViewModel
    @State private var userEmail: String = ""
    @State private var isEmailVerified: Bool = false
    @State private var showDeleteConfirmationDialog = false
    @State private var navigateToLogin = false

    var body: some View {
        VStack(spacing: 20) {
            NavigationLink(
                destination: AuthView()
                    .navigationBarBackButtonHidden(true),
                isActive: $navigateToLogin
            ) {
                EmptyView()
            }

            Text("Account Details")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Theme.primaryTextColor)
                .padding(.top, 40)

            HStack {
                Text("Disc Points:")
                    .font(.title2)
                    .foregroundColor(Theme.highlightColor)
                Spacer()
                Text("\(userDiscViewModel.discPoints)")
                    .font(.title2)
                    .foregroundColor(Theme.highlightColor)
            }
            .padding()
            .background(Theme.accentColor.opacity(0.2))
            .cornerRadius(10)

            VStack(alignment: .leading, spacing: 10) {
                Text("Email: \(userEmail)")
                    .font(.headline)
                    .foregroundColor(Theme.primaryTextColor)
            }
            .padding()
            .background(Theme.accentColor.opacity(0.2))
            .cornerRadius(10)
            .shadow(radius: 5)

            // Sign Out Button
            Button(action: signOut) {
                Text("Sign Out")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding()

            // Delete Account Button
            Button(action: {
                showDeleteConfirmationDialog = true
            }) {
                Text("Delete Account")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding()
            .confirmationDialog(
                "Are you sure you want to permanently delete your account?",
                isPresented: $showDeleteConfirmationDialog,
                titleVisibility: .visible
            ) {
                Button("Delete Account", role: .destructive) {
                    deleteAccount()
                }
                Button("Cancel", role: .cancel) {}
            }

            Spacer()

            Text("DiscTracker - Manage Your Game, Anytime.")
                .font(.footnote)
                .foregroundColor(Theme.secondaryTextColor)
                .padding(.bottom, 20)
        }
        .onAppear {
            userDiscViewModel.loadUser()
            loadUserDetails()
        }
        .padding()
        .background(Theme.backgroundColor.edgesIgnoringSafeArea(.all))
    }

    private func loadUserDetails() {
        if let user = Auth.auth().currentUser {
            self.userEmail = user.email ?? "Unknown"
            self.isEmailVerified = user.isEmailVerified
        }
    }

    private func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }

    private func deleteAccount() {
        guard let user = Auth.auth().currentUser else {
            return
        }

        let userRef = Firestore.firestore().collection("users").document(user.uid)

        // First delete the user document from Firestore
        userRef.delete { error in
            if let error = error {
                print("Error deleting user document: \(error)")
                // Optionally show user-facing error alert
                return
            }

            // Then delete the user from Firebase Authentication
            user.delete { error in
                if let error = error {
                    print("Error deleting user from Auth: \(error)")
                    // Optionally show user-facing error message or require re-authentication
                    return
                }

                // Sign out the user after deletion
                do {
                    try Auth.auth().signOut()
                } catch let signOutError as NSError {
                    print("Error signing out after account deletion: %@", signOutError)
                }

                // Navigate to login screen
                navigateToLogin = true
            }
        }
    }
}
