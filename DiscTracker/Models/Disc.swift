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
    var favorite: Bool
    
    // Flight numbers
    var speed: Double
    var glide: Double
    var turn: Double
    var fade: Double

    mutating func toggleLostStatus() {
        lost.toggle()
    }

    mutating func toggleTradedStatus() {
        traded.toggle()
    }

    mutating func updateCondition(to newCondition: String) {
        condition = newCondition
    }
    
    mutating func toggleFavoriteStatus() {
        favorite.toggle()
    }
}
