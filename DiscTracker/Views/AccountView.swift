//
//  AccountView.swift
//  DiscTracker
//
//  Created by Asher Antrim on 11/20/24.
//

import SwiftUI
import FirebaseAuth

struct AccountView: View {
    @StateObject var userDiscViewModel: UserDiscViewModel
    @State private var userEmail: String = ""
    @State private var isEmailVerified: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            // Header
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
                Text("\(userDiscViewModel.discPoints)")  // Display the discPoints from UserDiscViewModel
                    .font(.title2)
                    .foregroundColor(Theme.highlightColor)
            }
            .padding()
            .background(Theme.accentColor.opacity(0.2))
            .cornerRadius(10)

            // User Info Section
            VStack(alignment: .leading, spacing: 10) {
                Text("Email: \(userEmail)")
                    .font(.headline)
                    .foregroundColor(Theme.primaryTextColor)

                Text("Email Verified: \(isEmailVerified ? "Yes" : "No")")
                    .font(.subheadline)
                    .foregroundColor(isEmailVerified ? .green : .red)
            }
            .padding()
            .background(Theme.accentColor.opacity(0.2))
            .cornerRadius(10)
            .shadow(radius: 5)

            // Sign-Out Button
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

            Spacer()

            // Footer with branding or app message
            Text("DiscTracker - Manage Your Game, Anytime.")
                .font(.footnote)
                .foregroundColor(Theme.secondaryTextColor)
                .padding(.bottom, 20)
        }
        .onAppear {
            userDiscViewModel.loadUser()
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
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        let userDiscViewModel = UserDiscViewModel()
        AccountView(userDiscViewModel: userDiscViewModel)
    }
}
