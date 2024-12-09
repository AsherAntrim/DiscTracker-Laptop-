//
//  UserDataManager.swift
//  DiscTracker
//
//  Originally by Asher Antrim and Nathan Hollis on 11/22/24.
//  Modified by OpenAI on 12/09/24.
//
//  This version stores and retrieves the User from Firestore rather than UserDefaults.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class UserDataManager {
    private let db = Firestore.firestore()
    
    /// Fetch user data from Firestore. If no document is found, it creates a new user document.
    func loadUser(completion: @escaping (User?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(nil)
            return
        }
        
        let userRef = db.collection("users").document(currentUser.uid)
        userRef.getDocument { document, error in
            if let error = error {
                print("Error fetching user: \(error.localizedDescription)")
                completion(nil)
                return
            }

            if let document = document, document.exists {
                do {
                    let user = try document.data(as: User.self)
                    completion(user)
                } catch {
                    print("Failed to decode user: \(error.localizedDescription)")
                    completion(nil)
                }
            } else {
                // User document does not exist, create a default user
                let newUser = User(
                    id: currentUser.uid,
                    username: currentUser.displayName ?? "DefaultUser",
                    email: currentUser.email ?? "default@example.com",
                    discPoints: 0
                )
                self.saveUser(newUser) { success in
                    completion(success ? newUser : nil)
                }
            }
        }
    }

    /// Saves the user object to Firestore.
    func saveUser(_ user: User, completion: ((Bool) -> Void)? = nil) {
        let userRef = db.collection("users").document(user.id)
        do {
            try userRef.setData(from: user) { error in
                if let error = error {
                    print("Failed to save user: \(error.localizedDescription)")
                    completion?(false)
                } else {
                    completion?(true)
                }
            }
        } catch {
            print("Failed to encode user: \(error.localizedDescription)")
            completion?(false)
        }
    }

    /// Updates the user's discPoints in Firestore.
    func updateDiscPoints(for user: User, points: Int, completion: ((User?) -> Void)? = nil) {
        let updatedPoints = max(0, user.discPoints + points)
        var updatedUser = user
        updatedUser.discPoints = updatedPoints

        saveUser(updatedUser) { success in
            if success {
                completion?(updatedUser)
            } else {
                completion?(nil)
            }
        }
    }
}
