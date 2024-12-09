//
//  UserViewModel.swift
//  DiscTracker
//
//  Originally by Asher Antrim and Nathan Hollis on 11/22/24.
//  Modified by OpenAI on 12/09/24.
//
//  Now uses Firestore to store discPoints instead of UserDefaults.
//

import Foundation
import SwiftUI
import FirebaseAuth

class UserDiscViewModel: ObservableObject {
    @Published var user: User?
    @Published var discPoints: Int = 0
    
    private let userManager = UserDataManager()

    init() {
        loadUser()
    }

    func loadUser() {
        userManager.loadUser { [weak self] loadedUser in
            DispatchQueue.main.async {
                if let loadedUser = loadedUser {
                    self?.user = loadedUser
                    self?.discPoints = loadedUser.discPoints
                } else {
                    self?.user = nil
                    self?.discPoints = 0
                }
            }
        }
    }

    func addDiscPoints(_ points: Int) {
        guard let currentUser = user else {
            print("No user available to add disc points.")
            return
        }

        userManager.updateDiscPoints(for: currentUser, points: points) { [weak self] updatedUser in
            DispatchQueue.main.async {
                if let updatedUser = updatedUser {
                    self?.user = updatedUser
                    self?.discPoints = updatedUser.discPoints
                } else {
                    print("Failed to update disc points in Firestore.")
                }
            }
        }
    }

    func removeDiscPoints(_ points: Int) {
        guard let currentUser = user else {
            print("No user available to remove disc points.")
            return
        }

        userManager.updateDiscPoints(for: currentUser, points: -points) { [weak self] updatedUser in
            DispatchQueue.main.async {
                if let updatedUser = updatedUser {
                    self?.user = updatedUser
                    self?.discPoints = updatedUser.discPoints
                } else {
                    print("Failed to update disc points in Firestore.")
                }
            }
        }
    }

    func resetDiscPoints() {
        guard let currentUser = user else {
            print("No user available to reset disc points.")
            return
        }

        userManager.updateDiscPoints(for: currentUser, points: -currentUser.discPoints) { [weak self] updatedUser in
            DispatchQueue.main.async {
                if let updatedUser = updatedUser {
                    self?.user = updatedUser
                    self?.discPoints = updatedUser.discPoints
                } else {
                    print("Failed to reset disc points in Firestore.")
                }
            }
        }
    }
}
