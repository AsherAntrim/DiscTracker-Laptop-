//
//  SortType.swift
//  DiscTracker
//
//  Created by Asher Antrim on 11/15/24.
//

import Foundation

enum SortType: String, CaseIterable, Identifiable {
    case name, type, plastic, condition, lost, traded, favorite

    var id: String { self.rawValue }

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
        case .favorite:
            return { $0.favorite && !$1.favorite }
        }
    }
}
