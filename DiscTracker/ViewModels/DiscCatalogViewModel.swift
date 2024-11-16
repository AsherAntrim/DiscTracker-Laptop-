//
//  DiscCatalogViewModel.swift
//  DiscTracker
//
//  Created by Asher Antrim on 9/11/24.
//

import Foundation
import SwiftUI

/// ViewModel that manages the disc catalog data and provides it to the views.
class DiscCatalogViewModel: ObservableObject {
    @Published var discs: [Disc] = []
    @Published var sortType: SortType = .name
    
    private let dataManager = DiscDataManager()
    
    /// Adds a new disc to the catalog.
    ///
    /// - Parameters:
    ///   - name: The name of the disc.
    ///   - type: The type/category of the disc.
    ///   - plasticType: The plastic type of the disc.
    ///   - condition: The condition of the disc.
    ///   - imageData: Optional image data for the disc.
    func addDisc(name: String, type: String, plasticType: String, condition: String, imageData: Data?) {
        let newDisc = Disc(name: name, type: type, plasticType: plasticType, condition: condition, imageData: imageData)
        discs.append(newDisc)
        dataManager.saveDiscs(discs)
    }
    
    /// Removes a disc from the catalog at the specified offsets.
    ///
    /// - Parameter offsets: The index set of discs to remove.
    func removeDisc(at offsets: IndexSet) {
        discs.remove(atOffsets: offsets)
        dataManager.saveDiscs(discs)
    }
    
    /// Loads the discs from the data manager.
    func loadDiscs() {
        discs = dataManager.loadDiscs()
    }
    
    /// Returns the discs filtered based on the search text and sorted based on the current sort type.
    ///
    /// - Parameter searchText: The text to filter discs by.
    /// - Returns: An array of discs filtered and sorted.
    func getFilteredAndSortedDiscs(searchText: String) -> [Disc] {
        let filteredDiscs = dataManager.filterDiscs(discs, searchText: searchText)
        return dataManager.sortDiscs(filteredDiscs, by: sortType)
    }
}
