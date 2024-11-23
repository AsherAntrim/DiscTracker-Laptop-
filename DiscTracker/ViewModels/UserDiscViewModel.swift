//
//  UserViewModel.swift
//  DiscTracker
//
//  Created by Asher Antrim and Nathan Hollis on 11/22/24.
//

import Foundation
import SwiftUI

/// ViewModel that manages the user's discPoints and provides it to the views.
class UserDiscViewModel: ObservableObject {
    @Published var user: User? // The current user object
    @Published var discPoints: Int = 0 // User's discPoints
    private let userManager = UserDataManager()

    /// Initializes the view model and loads the user data.
    init() {
        loadUser()
    }

    /// Adds discPoints to the user's account.
    func addDiscPoints(_ points: Int) {
        guard var currentUser = user else {
            print("Error: No user object available.")
            return
        }
        currentUser.discPoints += points
        updateUser(currentUser)
    }

    /// Removes discPoints from the user's account.
    func removeDiscPoints(_ points: Int) {
        guard var currentUser = user else { return }
        currentUser.discPoints = max(0, currentUser.discPoints - points) // Prevent negative points
        discPoints = currentUser.discPoints
        userManager.saveUser(currentUser)
        user = currentUser
    }
    
    private func updateUser(_ updatedUser: User) {
        user = updatedUser
        discPoints = updatedUser.discPoints
        userManager.saveUser(updatedUser)
    }

    /// Loads the user data from the data manager.
    func loadUser(completion: ((Int) -> Void)? = nil) {
        if let loadedUser = userManager.loadUser() {
            user = loadedUser
            discPoints = loadedUser.discPoints
            completion?(loadedUser.discPoints)
        } else {
            // Create a default user if none exists
            let defaultUser = User(id: UUID().uuidString, username: "DefaultUser", email: "default@example.com", discPoints: 0)
            userManager.saveUser(defaultUser)
            user = defaultUser
            discPoints = defaultUser.discPoints
            completion?(defaultUser.discPoints)
        }
    }
    
    /// Creates a default user if no user data is found.
    private func createDefaultUser() {
        let defaultUser = User(id: UUID().uuidString, username: "DefaultUser", email: "default@example.com", discPoints: 0)
        updateUser(defaultUser)
    }

    /// Resets the user's discPoints to zero.
    func resetDiscPoints() {
        guard var currentUser = user else {
            print("Error: No user object available.")
            return
        }
        currentUser.discPoints = 0
        updateUser(currentUser)
    }
}
