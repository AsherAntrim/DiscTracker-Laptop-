//
//  AccountView.swift
//  DiscTracker
//
//  Created by Asher Antrim on 11/20/24.
//

import SwiftUI
import FirebaseAuth

struct AccountView: View {
    @ObservedObject var userDiscViewModel: UserDiscViewModel
    @State private var userEmail: String = ""
    @State private var isEmailVerified: Bool = false

    // DiscTracker-themed colors
    let backgroundColor = Color(red: 34/255, green: 139/255, blue: 34/255) // Green - representing outdoors
    let accentColor = Color(red: 60/255, green: 70/255, blue: 80/255) // Neutral accent color
    let highlightColor = Color(red: 255/255, green: 223/255, blue: 0/255) // Yellow for highlights

    var body: some View {
        VStack(spacing: 20) {
            // Header
            Text("Account Details")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(highlightColor) // Highlight color for title
                .padding(.top, 40)
            
            HStack {
                Text("Disc Points:")
                    .font(.title2)
                    .foregroundColor(highlightColor)
                Spacer()
                Text("\(userDiscViewModel.discPoints)")
                    .font(.title2)
                    .foregroundColor(highlightColor)
            }
            .padding()
            .background(accentColor.opacity(0.2))
            .cornerRadius(10)

            // User Info Section
            VStack(alignment: .leading, spacing: 10) {
                Text("Email: \(userEmail)")
                    .font(.headline)
                    .foregroundColor(accentColor) // Accent color for text

                Text("Email Verified: \(isEmailVerified ? "Yes" : "No")")
                    .font(.subheadline)
                    .foregroundColor(isEmailVerified ? .green : .red) // Green or red depending on verification
            }
            .padding()
            .background(accentColor.opacity(0.2)) // Subtle background with neutral color
            .cornerRadius(10)
            .shadow(radius: 5)
            
            // Add Points Button
            Button(action: {
                userDiscViewModel.addDiscPoints(10)
            }) {
                Text("Add 10 Points")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding()

            // Remove Points Button
            Button(action: {
                userDiscViewModel.removeDiscPoints(5)
            }) {
                Text("Remove 5 Points")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding()

            Spacer()

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
                .foregroundColor(accentColor)
                .padding(.bottom, 20)
        }
        .onAppear {
            loadUserDetails()
        }
        .padding()
        .background(backgroundColor.edgesIgnoringSafeArea(.all)) // Themed green background
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
