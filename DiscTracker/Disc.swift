//
//  Disc.swift
//  DiscTracker
//
//  Created by Asher Antrim on 9/11/24.
//
import Foundation

struct Disc: Identifiable, Codable {
    var id = UUID()   // Unique identifier for each disc
    var name: String  // Name of the disc
    var type: String  // Type of disc (e.g., driver, mid-range, putter)
    var plasticType: String  // Plastic type (e.g., Star, Champion, DX)
    var condition: String    // Condition of the disc (e.g., new, used)
    var lost: Bool = false   // Track if the disc is lost
    var traded: Bool = false
    var imageData: Data?

}

