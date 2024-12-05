//
//  DiscCatalogViewModel.swift
//  DiscTracker
//
//  Created by Asher Antrim on 9/11/24.
//

import FirebaseFirestore
import FirebaseAuth

class DiscCatalogViewModel: ObservableObject {
    @Published var discs: [Disc] = []
    @Published var sortType: SortType = .name
    private let db = Firestore.firestore()
    private let userDiscViewModel = UserDiscViewModel()

    func addDisc(name: String, type: String, plasticType: String, condition: String, imageData: Data?) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let newDisc = Disc(
            id: UUID(),
            name: name,
            type: type,
            plasticType: plasticType,
            condition: condition,
            imageData: imageData,
            lost: false,
            traded: false
        )
        discs.append(newDisc)
        userDiscViewModel.handleDiscAddition(currentDiscCount: discs.count)
        
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
                    } else {
                        print("Disc successfully saved to Firestore.")
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
            }
        }
    }

    func removeDisc(at offsets: IndexSet) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        offsets.map { discs[$0] }.forEach { disc in
            deleteDiscFromFirestore(disc: disc, userId: userId)
        }
        discs.remove(atOffsets: offsets)
    }
    
    func updateDiscStatus(disc: Disc, userId: String) {
        let userDiscsRef = db.collection("users").document(userId).collection("discs")
        
        let updatedData: [String: Any] = [
            "lost": disc.lost,
            "traded": disc.traded
        ]
        
        userDiscsRef.document(disc.id.uuidString).updateData(updatedData) { error in
            if let error = error {
                print("Error updating disc status in Firestore: \(error.localizedDescription)")
            } else {
                print("Disc status successfully updated in Firestore.")
            }
        }
    }

    private func deleteDiscFromFirestore(disc: Disc, userId: String) {
        let userDiscsRef = db.collection("users").document(userId).collection("discs")
        userDiscsRef.document(disc.id.uuidString).delete { error in
            if let error = error {
                print("Error deleting disc from Firestore: \(error.localizedDescription)")
            } else {
                print("Disc successfully deleted from Firestore.")
            }
        }
    }
}
