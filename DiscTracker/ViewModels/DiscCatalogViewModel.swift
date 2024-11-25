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
    private let userDiscViewModel = UserDiscViewModel()

    /// Initializes the catalog view model with a reference to the user disc view model.
    init() {
        loadDiscs()
    }
    
    /// Adds a new disc to the catalog.
    func addDisc(name: String, type: String, plasticType: String, condition: String, imageData: Data?) {
        let newDisc = Disc(name: name, type: type, plasticType: plasticType, condition: condition, imageData: imageData)
        discs.append(newDisc)
        dataManager.saveDiscs(discs)
        
        userDiscViewModel.handleDiscAddition(currentDiscCount: discs.count)
    }

    /// Removes a disc from the catalog at the specified offsets.
    func removeDisc(at offsets: IndexSet) {
        discs.remove(atOffsets: offsets)
        dataManager.saveDiscs(discs)
    }

    /// Loads the discs from the data manager.
    func loadDiscs() {
        discs = dataManager.loadDiscs()
    }

    /// Returns the discs sorted based on the current sort type.
    var sortedDiscs: [Disc] {
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
}
