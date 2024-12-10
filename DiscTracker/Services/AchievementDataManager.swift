//
//  AchievementDataManager.swift
//  DiscTracker
//
//  Created by Nathan Hollis on 12/8/24.
//  Modified by OpenAI on 12/09/24.
//  Updated to use stable UUIDs for each achievement.
//

import Foundation

class AchievementDataManager {
    static let shared = AchievementDataManager()
    private init() {}

    // Predefined stable UUIDs for each achievement.
    // Generate these once and never change them.
    // You can use any UUID generator to produce these once and hard-code them here.
    private let firstDiscID = UUID(uuidString: "9f85de64-8fcb-4492-9657-6d8df662d0a0")!
    private let discEnthusiastID = UUID(uuidString: "3c80de77-f239-42f0-85ac-9753249d72f1")!
    private let discCollectorID = UUID(uuidString: "67472f06-9797-4e15-b3be-4ac88ee1c449")!
    private let discConnoisseurID = UUID(uuidString: "ad836b5f-104f-4311-a121-8abd2f3b38a6")!
    private let discMasterID = UUID(uuidString: "527c06f1-ced3-40bb-ad76-559bd6e6a5c5")!
    private let discPointMagnetID = UUID(uuidString: "b5148c39-8a38-4377-b001-aaf0b1c95b1b")!
    private let discAficionadoID = UUID(uuidString: "6c65c9ff-0330-4b0a-9ba5-2e3f0f75cc83")!

    let achievements: [Achievement] = [
        Achievement(
            id: UUID(uuidString: "9f85de64-8fcb-4492-9657-6d8df662d0a0")!,
            title: "First Disc",
            description: "Catalog your first disc",
            points: 10,
            requiredDiscCount: 1,
            requiredDiscPoints: nil,
            requiredFavorites: nil,
            isEarned: false
        ),
        Achievement(
            id: UUID(uuidString: "3c80de77-f239-42f0-85ac-9753249d72f1")!,
            title: "Disc Enthusiast",
            description: "Catalog 10 discs",
            points: 50,
            requiredDiscCount: 10,
            requiredDiscPoints: nil,
            requiredFavorites: nil,
            isEarned: false
        ),
        Achievement(
            id: UUID(uuidString: "67472f06-9797-4e15-b3be-4ac88ee1c449")!,
            title: "Disc Collector",
            description: "Catalog 25 discs",
            points: 100,
            requiredDiscCount: 25,
            requiredDiscPoints: nil,
            requiredFavorites: nil,
            isEarned: false
        ),
        Achievement(
            id: UUID(uuidString: "ad836b5f-104f-4311-a121-8abd2f3b38a6")!,
            title: "Disc Connoisseur",
            description: "Catalog 50 discs",
            points: 250,
            requiredDiscCount: 50,
            requiredDiscPoints: nil,
            requiredFavorites: nil,
            isEarned: false
        ),
        Achievement(
            id: UUID(uuidString: "527c06f1-ced3-40bb-ad76-559bd6e6a5c5")!,
            title: "Disc Master",
            description: "Catalog 100 discs",
            points: 500,
            requiredDiscCount: 100,
            requiredDiscPoints: nil,
            requiredFavorites: nil,
            isEarned: false
        ),
        Achievement(
            id: UUID(uuidString: "b5148c39-8a38-4377-b001-aaf0b1c95b1b")!,
            title: "Disc Point Magnet",
            description: "Get 250 disc points at one time",
            points: 100,
            requiredDiscCount: nil,
            requiredDiscPoints: 250,
            requiredFavorites: nil,
            isEarned: false
        ),
        Achievement(
            id: UUID(uuidString: "6c65c9ff-0330-4b0a-9ba5-2e3f0f75cc83")!,
            title: "Disc Aficionado",
            description: "Mark 10 discs as favorites",
            points: 150,
            requiredDiscCount: nil,
            requiredDiscPoints: nil,
            requiredFavorites: 10,
            isEarned: false
        )
    ]
}
