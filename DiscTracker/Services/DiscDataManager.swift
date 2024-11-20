//
//  DiscDataManager.swift
//  DiscTracker
//
//  Created by Asher Antrim on 9/11/24.
//

import Foundation

/// Manages the data operations for discs, including saving and loading.
class DiscDataManager {
    private let userDefaultsKey = "savedDiscs"

    /// Saves the given array of discs to UserDefaults.
    func saveDiscs(_ discs: [Disc]) {
        do {
            let encodedData = try JSONEncoder().encode(discs)
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
        } catch {
            print("Failed to save discs: \(error.localizedDescription)")
        }
    }

    /// Loads the array of discs from UserDefaults.
    func loadDiscs() -> [Disc] {
        guard let savedData = UserDefaults.standard.data(forKey: userDefaultsKey) else { return [] }
        do {
            return try JSONDecoder().decode([Disc].self, from: savedData)
        } catch {
            print("Failed to load discs: \(error.localizedDescription)")
            return []
        }
    }
}
