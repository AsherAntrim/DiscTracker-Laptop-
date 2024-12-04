//
//  Disc.swift
//  DiscTracker
//
//  Created by Asher Antrim on 9/11/24.
//

import Foundation
import FirebaseFirestore


/// Represents a disc in the catalog with its attributes.
struct Disc: Identifiable, Codable {
    var id = UUID()
    var name: String
    var type: String
    var plasticType: String
    var condition: String
    var lost: Bool = false
    var traded: Bool = false
    var imageData: Data?
}
