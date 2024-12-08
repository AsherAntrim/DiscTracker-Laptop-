//
//  AchievementViewModel.swift
//  DiscTracker
//
//  Created by Nathan Hollis on 12/8/24.
//

import Foundation
import Combine

class AchievementViewModel: ObservableObject {
    @Published var achievements: [Achievement] = []
    
    // Add view models as dependencies
    private var userDiscViewModel: UserDiscViewModel
    private var discCatalogViewModel: DiscCatalogViewModel
    
    init(userDiscViewModel: UserDiscViewModel, discCatalogViewModel: DiscCatalogViewModel) {
        self.userDiscViewModel = userDiscViewModel
        self.discCatalogViewModel = discCatalogViewModel
        loadAchievements()
        
        // Re-evaluate achievements when the user disc points change or when disc catalog changes
        self.userDiscViewModel.$discPoints
            .sink { [weak self] _ in self?.loadAchievements() }
            .store(in: &cancellables)
        
        self.discCatalogViewModel.$discCount
            .sink { [weak self] _ in self?.loadAchievements() }
            .store(in: &cancellables)
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    func loadAchievements() {
        // Create a copy of achievements that can be modified
        var updatedAchievements = AchievementDataManager.shared.achievements
        
        // Update each achievement's earned status
        for index in 0..<updatedAchievements.count {
            updatedAchievements[index] = updateAchievementStatus(updatedAchievements[index])
        }
        
        // Update the published achievements
        achievements = updatedAchievements
    }
    
    private func updateAchievementStatus(_ achievement: Achievement) -> Achievement {
        var mutableAchievement = achievement
        
        // Check if achievement is earned based on disc count or points
        mutableAchievement.isEarned = isAchievementEarned(
            achievement,
            discCount: discCatalogViewModel.discCount,
            discPoints: userDiscViewModel.discPoints
        )
        
        return mutableAchievement
    }
    
    func isAchievementEarned(_ achievement: Achievement, discCount: Int, discPoints: Int) -> Bool {
        // Check disc count requirement
        if let requiredDiscCount = achievement.requiredDiscCount {
            if discCount >= requiredDiscCount {
                return true
            }
        }
        
        // Check disc points requirement
        if let requiredDiscPoints = achievement.requiredDiscPoints {
            if discPoints >= requiredDiscPoints {
                return true
            }
        }
        
        return false
    }
}
