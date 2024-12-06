//
//  Disc.swift
//  DiscTracker
//
//  Created by Asher Antrim on 9/11/24.
//

import Foundation

struct Disc: Codable, Identifiable {
    var id: UUID
    var name: String
    var type: String
    var plasticType: String
    var condition: String
    var lost: Bool
    var traded: Bool

    /// Toggles the lost status of the disc.
    mutating func toggleLostStatus() {
        lost.toggle()
    }

    /// Toggles the traded status of the disc.
    mutating func toggleTradedStatus() {
        traded.toggle()
    }

    /// Updates the condition of the disc.
    mutating func updateCondition(to newCondition: String) {
        condition = newCondition
    }
}
