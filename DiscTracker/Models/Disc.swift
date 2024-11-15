//
//  Disc.swift
//  DiscTracker
//
//  Created by Asher Antrim on 9/11/24.
//
import Foundation

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

enum SortType: String, CaseIterable, Identifiable {
    case name, type, plastic, condition, lost, traded
    
    var id: String { self.rawValue }
}

