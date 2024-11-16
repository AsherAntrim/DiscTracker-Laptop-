//
//  DiscDataManager.swift
//  DiscTracker
//
//  Created by Asher Antrim on 9/11/24.
//
//  ChatGPT Integration:
//  Used ChatGPT to brainstorm the structure of data processing methods,
//  and to refine the logic for sorting and filtering discs in the model layer.

import Foundation

/// Manages the data operations for discs, including saving, loading, sorting, and filtering.
class DiscDataManager {
    private let userDefaultsKey = "savedDiscs"
    
    /// Saves the given array of discs to UserDefaults.
    ///
    /// - Parameter discs: The array of discs to save.
    func saveDiscs(_ discs: [Disc]) {
        do {
            let encodedData = try JSONEncoder().encode(discs)
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
        } catch {
            print("Failed to save discs: \(error.localizedDescription)")
        }
    }
    
    /// Loads the array of discs from UserDefaults.
    ///
    /// - Returns: An array of discs loaded from storage.
    func loadDiscs() -> [Disc] {
        guard let savedData = UserDefaults.standard.data(forKey: userDefaultsKey) else { return [] }
        do {
            return try JSONDecoder().decode([Disc].self, from: savedData)
        } catch {
            print("Failed to load discs: \(error.localizedDescription)")
            return []
        }
    }
    
    /// Sorts the given array of discs based on the specified sort type.
    ///
    /// - Parameters:
    ///   - discs: The array of discs to sort.
    ///   - sortType: The type of sorting to apply.
    /// - Returns: A new array of discs sorted based on the sort type.
    func sortDiscs(_ discs: [Disc], by sortType: SortType) -> [Disc] {
        switch sortType {
        case .name:
            return discs.sorted { $0.name < $1.name }
        case .type:
            return discs.sorted { $0.type < $1.type }
        case .plastic:
            return discs.sorted { $0.plasticType < $1.plasticType }
        case .condition:
            return discs.sorted { $0.condition < $1.condition }
        case .lost:
            return discs.filter { $0.lost }
        case .traded:
            return discs.filter { $0.traded }
        }
    }
    
    /// Filters the given array of discs based on the search text.
    ///
    /// - Parameters:
    ///   - discs: The array of discs to filter.
    ///   - searchText: The text to search for in disc attributes.
    /// - Returns: A new array of discs that match the search text.
    func filterDiscs(_ discs: [Disc], searchText: String) -> [Disc] {
        guard !searchText.isEmpty else { return discs }
        return discs.filter { disc in
            disc.name.localizedCaseInsensitiveContains(searchText) ||
            disc.type.localizedCaseInsensitiveContains(searchText) ||
            disc.plasticType.localizedCaseInsensitiveContains(searchText)
        }
    }
}
