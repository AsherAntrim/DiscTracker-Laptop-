//
//  AccountView.swift
//  DiscTracker
//
//  Created by Asher Antrim on 11/20/24.
//  Modified by OpenAI on 12/09/24.
//

import SwiftUI
import FirebaseAuth

struct AccountView: View {
    @StateObject var userDiscViewModel: UserDiscViewModel
    @State private var userEmail: String = ""
    @State private var isEmailVerified: Bool = false

    var body: some View {
        VStack(spacing: 20) {
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
}
