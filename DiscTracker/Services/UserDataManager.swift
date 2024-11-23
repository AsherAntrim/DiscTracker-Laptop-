//
//  UserDataManager.swift
//  DiscTracker
//
//  Created by Asher Antrim and Nathan Hollis on 11/22/24.
//

import Foundation

/// Manages the data operations for the User model, including saving, loading, and updating discPoints.
class UserDataManager {
    private let userDefaultsKey = "savedUser"

    /// Saves the User object to UserDefaults.
    func saveUser(_ user: User) {
        do {
            let encodedData = try JSONEncoder().encode(user)
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
        } catch {
            print("Failed to save user: \(error.localizedDescription)")
        }
    }

    /// Loads the User object from UserDefaults.
    func loadUser() -> User? {
        guard let savedData = UserDefaults.standard.data(forKey: userDefaultsKey) else { return nil }
        do {
            return try JSONDecoder().decode(User.self, from: savedData)
        } catch {
            print("Failed to load user: \(error.localizedDescription)")
            return nil
        }
    }

    /// Updates the user's discPoints and saves the updated user object.
    func updateDiscPoints(for user: User, points: Int) -> User {
        var updatedUser = user
        updatedUser.discPoints += points
        saveUser(updatedUser)
        return updatedUser
    }
}
