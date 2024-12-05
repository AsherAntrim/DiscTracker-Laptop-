//
//  SortType.swift
//  DiscTracker
//
//  Created by Asher Antrim on 11/15/24.
//

import Foundation

/// Enum representing the different types of sorting available for discs.
enum SortType: String, CaseIterable, Identifiable {
    case name, type, plastic, condition, lost, traded

    var id: String { self.rawValue }

    /// Returns a closure that can be used to sort an array of discs by this sort type.
    func sortClosure() -> (Disc, Disc) -> Bool {
        switch self {
        case .name:
            return { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .type:
            return { $0.type.localizedCaseInsensitiveCompare($1.type) == .orderedAscending }
        case .plastic:
            return { $0.plasticType.localizedCaseInsensitiveCompare($1.plasticType) == .orderedAscending }
        case .condition:
            return { $0.condition.localizedCaseInsensitiveCompare($1.condition) == .orderedAscending }
        case .lost:
            return { $0.lost && !$1.lost }
        case .traded:
            return { $0.traded && !$1.traded }
        }
    }
}
