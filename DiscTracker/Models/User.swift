//
//  User.swift
//  DiscTracker
//
//  Created by Asher Antrim on 11/15/24.
//

import Foundation
import FirebaseFirestore


/// Represents a user in the app.
struct User: Codable {
    var id: String
    var username: String
    var email: String
    var discPoints: Int
    var maxDiscsCataloged: Int
}
