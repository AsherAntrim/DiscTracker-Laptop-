//
//  Achievement.swift
//  DiscTracker
//
//  Created by Asher Antrim on 11/15/24.
//

import Foundation

struct Achievement: Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String
    var points: Int
    var requiredDiscCount: Int?
    var requiredDiscPoints: Int?
    var isEarned: Bool = false
}
