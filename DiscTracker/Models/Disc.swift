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
    var imageData: Data?
    var lost: Bool
    var traded: Bool
}
