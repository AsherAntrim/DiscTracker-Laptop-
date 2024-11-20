//
//  Achievement.swift
//  DiscTracker
//
//  Created by Asher Antrim on 11/15/24.
//

import Foundation

/// Represents an achievement that a user can earn.
struct Achievement: Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String
    var points: Int
    var isEarned: Bool = false
}
