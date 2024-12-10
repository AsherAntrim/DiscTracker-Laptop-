//
//  DiscCatalogViewModel.swift
//  DiscTracker
//
//  Created by Asher Antrim on 9/11/24.
//  Modified by OpenAI on 12/09/24.
//

import FirebaseFirestore
import FirebaseAuth
import SwiftUI

class DiscCatalogViewModel: ObservableObject {
    @Published var discs: [Disc] = []
    @Published var discCount: Int = 0
    @Published var favoriteCount: Int = 0
    @Published var sortType: SortType = .name
    
    private let db = Firestore.firestore()
    private let userDiscViewModel = UserDiscViewModel()

    func addDisc(name: String, type: String, plasticType: String, condition: String, speed: Double, glide: Double, turn: Double, fade: Double) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let newDisc = Disc(
            id: UUID(),
            name: name,
            type: type,
            plasticType: plasticType,
            condition: condition,
            lost: false,
            traded: false,
            favorite: false,
            speed: speed,
            glide: glide,
            turn: turn,
            fade: fade
        )
        discs.append(newDisc)
        userDiscViewModel.addDiscPoints(10)
        
        countDiscs()
        countFavorites()
        saveDiscToFirestore(disc: newDisc, userId: userId)
    }

    private func saveDiscToFirestore(disc: Disc, userId: String) {
        let userDiscsRef = db.collection("users").document(userId).collection("discs")
        do {
            let encodedDisc = try JSONEncoder().encode(disc)
            if let jsonData = try JSONSerialization.jsonObject(with: encodedDisc) as? [String: Any] {
                userDiscsRef.document(disc.id.uuidString).setData(jsonData) { error in
                    if let error = error {
                        print("Error saving disc to Firestore: \(error.localizedDescription)")
                    }
                }
            }
        } catch {
            print("Failed to encode disc: \(error.localizedDescription)")
        }
    }

    func loadDiscs() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let userDiscsRef = db.collection("users").document(userId).collection("discs")
        userDiscsRef.getDocuments { snapshot, error in
            if let error = error {
                print("Failed to load discs from Firestore: \(error.localizedDescription)")
                return
            }

            var loadedDiscs: [Disc] = []
            snapshot?.documents.forEach { document in
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: document.data(), options: [])
                    let disc = try JSONDecoder().decode(Disc.self, from: jsonData)
                    loadedDiscs.append(disc)
                } catch {
                    print("Failed to decode disc: \(error.localizedDescription)")
                }
            }

            DispatchQueue.main.async {
                self.discs = loadedDiscs
                self.countDiscs()
                self.countFavorites()
            }
        }
    }

    func removeDisc(at offsets: IndexSet) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        offsets.map { discs[$0] }.forEach { disc in
            deleteDiscFromFirestore(disc: disc, userId: userId)
        }
        discs.remove(atOffsets: offsets)
        countDiscs()
        countFavorites()
    }

    func updateDiscStatus(disc: Disc, userId: String) {
        let userDiscsRef = db.collection("users").document(userId).collection("discs")
        
        do {
            let encoded = try JSONEncoder().encode(disc)
            if let jsonData = try JSONSerialization.jsonObject(with: encoded) as? [String: Any] {
                userDiscsRef.document(disc.id.uuidString).setData(jsonData) { error in
                    if let error = error {
                        print("Error updating disc in Firestore: \(error.localizedDescription)")
                    }
                }
            }
        } catch {
            print("Failed to encode updated disc: \(error.localizedDescription)")
        }
        countFavorites()
    }

    private func deleteDiscFromFirestore(disc: Disc, userId: String) {
        let userDiscsRef = db.collection("users").document(userId).collection("discs")
        userDiscsRef.document(disc.id.uuidString).delete { error in
            if let error = error {
                print("Error deleting disc: \(error.localizedDescription)")
            }
        }
    }
    
    func countDiscs() {
        discCount = discs.count
    }
    
    func countFavorites() {
        favoriteCount = discs.filter { $0.favorite }.count
    }
    
    func toggleFavorite(disc: Disc) {
        guard let index = discs.firstIndex(where: { $0.id == disc.id }) else { return }
        discs[index].toggleFavoriteStatus()
        
        if let userId = Auth.auth().currentUser?.uid {
            updateDiscStatus(disc: discs[index], userId: userId)
        }
    }
}

extension DiscCatalogViewModel {
    func recommendDisc(stability: String, distance: Int) -> Disc? {
        let filteredByStability: [Disc]
        switch stability.lowercased() {
        case "overstable":
            filteredByStability = discs.filter { ($0.turn + $0.fade) > 0 }
        case "understable":
            filteredByStability = discs.filter { ($0.turn + $0.fade) < 0 }
        case "stable":
            filteredByStability = discs.filter { ($0.turn + $0.fade) == 0 }
        default:
            filteredByStability = discs
        }

        let filteredByDistance: [Disc]
        if distance > 200 {
            filteredByDistance = filteredByStability.filter { $0.speed >= 9 }
        } else if distance >= 100 {
            filteredByDistance = filteredByStability.filter { $0.speed >= 4 && $0.speed <= 8 }
        } else {
            filteredByDistance = filteredByStability.filter { $0.speed < 4 }
        }

        return filteredByDistance.first
    }
}
