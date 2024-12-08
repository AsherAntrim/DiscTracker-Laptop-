//
//  AchievementDataManager.swift
//  DiscTracker
//
//  Created by Nathan Hollis on 12/8/24.
//

import Foundation

class AchievementDataManager {
    static let shared = AchievementDataManager()
    
    private init() {}
    
    let achievements: [Achievement] = [
        Achievement(title: "First Disc", description: "Catalog your first disc", points: 10, requiredDiscCount: 1),
        Achievement(title: "Disc Enthusiast", description: "Catalog 10 discs", points: 50, requiredDiscCount: 10),
        Achievement(title: "Disc Collector", description: "Catalog 25 discs", points: 100, requiredDiscCount: 25),
        Achievement(title: "Disc Connoisseur", description: "Catalog 50 discs", points: 250, requiredDiscCount: 50),
        Achievement(title: "Disc Master", description: "Catalog 100 discs", points: 500, requiredDiscCount: 100),
        Achievement(title: "Disc Point Magnet", description: "Get 250 disc points at one time", points: 100, requiredDiscPoints: 250)
    ]
}
