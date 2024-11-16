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
}
