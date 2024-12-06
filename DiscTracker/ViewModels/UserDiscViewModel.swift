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
    @Published var user: User?
    @Published var discPoints: Int = 0
    private let userManager = UserDataManager()

    /// Initializes the view model and loads the user data.
    init() {
        loadUser()
    }
    
    /// Rewards the user based on the number of discs they've cataloged.
    private func rewardUser(for catalogSize: Int) {
        let milestones = [10, 25, 50, 100] // Milestones for rewards
        let pointsReward = catalogSize * 10 // Adjust the points based on the number of cataloged discs

        if let nextMilestone = milestones.first(where: { $0 == catalogSize }) {
            print("Congratulations! You've cataloged \(nextMilestone) discs and earned \(pointsReward) points.")
            addDiscPoints(pointsReward) // Add points for the milestone
        }
    }

    /// Adds discPoints to the user's account.
    func addDiscPoints(_ points: Int) {
        guard var currentUser = user else {
            print("Error: No user object available.")
            return
        }
        currentUser.discPoints += points
        discPoints = currentUser.discPoints 
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
            createDefaultUser()
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
