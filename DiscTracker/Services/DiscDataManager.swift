//
//  DiscDataManager.swift
//  DiscTracker
//
//  Created by Asher Antrim on 9/11/24.
//

import Foundation
import FirebaseFirestore

class DiscDataManager {
    private let db = Firestore.firestore()

    /// Saves discs for the authenticated user.
    func saveDiscs(_ discs: [Disc], userId: String) {
        let userDiscsRef = db.collection("users").document(userId).collection("discs")

        // Clear existing data
        userDiscsRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error clearing discs: \(error.localizedDescription)")
                return
            }
            snapshot?.documents.forEach { $0.reference.delete() }
        }

        // Save updated data
        for disc in discs {
            do {
                let encodedDisc = try JSONEncoder().encode(disc)
                if let jsonData = try JSONSerialization.jsonObject(with: encodedDisc) as? [String: Any] {
                    userDiscsRef.document(disc.id.uuidString).setData(jsonData)
                }
            } catch {
                print("Failed to encode and save disc: \(error.localizedDescription)")
            }
        }
    }

    /// Loads discs for the authenticated user.
    func loadDiscs(userId: String, completion: @escaping ([Disc]) -> Void) {
        let userDiscsRef = db.collection("users").document(userId).collection("discs")

        userDiscsRef.getDocuments { snapshot, error in
            if let error = error {
                print("Failed to load discs: \(error.localizedDescription)")
                completion([])
                return
            }

            var discs: [Disc] = []
            snapshot?.documents.forEach { document in
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: document.data(), options: [])
                    let disc = try JSONDecoder().decode(Disc.self, from: jsonData)
                    discs.append(disc)
                } catch {
                    print("Failed to decode disc: \(error.localizedDescription)")
                }
            }
            completion(discs)
        }
    }
}
