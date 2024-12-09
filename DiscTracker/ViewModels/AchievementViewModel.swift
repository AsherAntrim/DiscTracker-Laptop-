import Foundation
import Combine

class AchievementViewModel: ObservableObject {
    @Published var achievements: [Achievement] = []
    
    private var userDiscViewModel: UserDiscViewModel
    private var discCatalogViewModel: DiscCatalogViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    private let earnedAchievementsKey = "earnedAchievementsIDs"
    private var achievementsPendingPoints: [Achievement] = []
    
    init(userDiscViewModel: UserDiscViewModel, discCatalogViewModel: DiscCatalogViewModel) {
        self.userDiscViewModel = userDiscViewModel
        self.discCatalogViewModel = discCatalogViewModel
        loadAchievements()
        
        userDiscViewModel.$discPoints
            .sink { [weak self] _ in self?.checkAndUpdateAchievements() }
            .store(in: &cancellables)
        
        discCatalogViewModel.$discCount
            .sink { [weak self] _ in self?.checkAndUpdateAchievements() }
            .store(in: &cancellables)
        
        discCatalogViewModel.$favoriteCount
            .sink { [weak self] _ in self?.checkAndUpdateAchievements() }
            .store(in: &cancellables)
        
        userDiscViewModel.$user
            .sink { [weak self] user in
                guard let self = self else { return }
                if user != nil {
                    // User just loaded, award any pending achievements
                    self.awardPendingAchievements()
                }
            }
            .store(in: &cancellables)
    }
    
    func loadAchievements() {
        let baseAchievements = AchievementDataManager.shared.achievements
        let earnedAchievementIDs = loadEarnedAchievements()
        
        achievements = baseAchievements.map { achievement in
            var updated = achievement
            if earnedAchievementIDs.contains(updated.id.uuidString) {
                updated.isEarned = true
            }
            return updated
        }
        
        checkAndUpdateAchievements()
    }
    
    private func checkAndUpdateAchievements() {
        var updatedAchievements = achievements
        var newlyEarnedAchievements: [Achievement] = []
        
        for index in 0..<updatedAchievements.count {
            let achievement = updatedAchievements[index]
            let currentlyEarned = achievement.isEarned
            let newEarnedStatus = isAchievementEarned(
                achievement,
                discCount: discCatalogViewModel.discCount,
                discPoints: userDiscViewModel.discPoints,
                favorites: discCatalogViewModel.favoriteCount
            )
            
            if newEarnedStatus && !currentlyEarned {
                updatedAchievements[index].isEarned = true
                saveEarnedAchievement(id: achievement.id)
                newlyEarnedAchievements.append(updatedAchievements[index])
            }
        }
        
        achievements = updatedAchievements
        
        // Attempt to award points for newly earned achievements
        awardAchievements(newlyEarnedAchievements)
    }
    
    private func awardAchievements(_ achievementsToAward: [Achievement]) {
        // If the user is not loaded yet, queue them
        guard let _ = userDiscViewModel.user else {
            achievementsPendingPoints.append(contentsOf: achievementsToAward)
            return
        }
        
        // User is loaded, award points immediately
        for achievement in achievementsToAward {
            userDiscViewModel.addDiscPoints(achievement.points)
        }
        
        // If any achievements were pending, try awarding them now
        if !achievementsPendingPoints.isEmpty {
            awardPendingAchievements()
        }
    }
    
    private func awardPendingAchievements() {
        guard !achievementsPendingPoints.isEmpty else { return }
        guard let _ = userDiscViewModel.user else {
            return
        }
        
        for achievement in achievementsPendingPoints {
            userDiscViewModel.addDiscPoints(achievement.points)
        }
        
        achievementsPendingPoints.removeAll()
    }
    
    private func isAchievementEarned(_ achievement: Achievement, discCount: Int, discPoints: Int, favorites: Int) -> Bool {
        if let requiredDiscCount = achievement.requiredDiscCount, discCount >= requiredDiscCount {
            return true
        }
        if let requiredDiscPoints = achievement.requiredDiscPoints, discPoints >= requiredDiscPoints {
            return true
        }
        if let requiredFavorites = achievement.requiredFavorites, favorites >= requiredFavorites {
            return true
        }
        return false
    }
    
    private func loadEarnedAchievements() -> [String] {
        UserDefaults.standard.stringArray(forKey: earnedAchievementsKey) ?? []
    }
    
    private func saveEarnedAchievement(id: UUID) {
        var earnedIDs = loadEarnedAchievements()
        if !earnedIDs.contains(id.uuidString) {
            earnedIDs.append(id.uuidString)
            UserDefaults.standard.set(earnedIDs, forKey: earnedAchievementsKey)
        }
    }
}
