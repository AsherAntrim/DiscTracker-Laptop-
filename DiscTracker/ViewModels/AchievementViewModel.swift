import Foundation
import Combine

class AchievementViewModel: ObservableObject {
    @Published var achievements: [Achievement] = []
    
    private var userDiscViewModel: UserDiscViewModel
    private var discCatalogViewModel: DiscCatalogViewModel
    private var cancellables: Set<AnyCancellable> = []
    private var initialUserLoadCompleted = false
    
    init(userDiscViewModel: UserDiscViewModel, discCatalogViewModel: DiscCatalogViewModel) {
        self.userDiscViewModel = userDiscViewModel
        self.discCatalogViewModel = discCatalogViewModel
        
        // Wait for user to load before loading achievements
        userDiscViewModel.$user
            .compactMap { $0 } // Proceed only when user is non-nil
            .sink { [weak self] user in
                // Once user is loaded, load achievements
                self?.loadAchievements()
            }
            .store(in: &cancellables)
        
        // Check achievements only when conditions change
        discCatalogViewModel.$discCount
            .sink { [weak self] _ in self?.checkAndUpdateAchievements() }
            .store(in: &cancellables)
        
        discCatalogViewModel.$favoriteCount
            .sink { [weak self] _ in self?.checkAndUpdateAchievements() }
            .store(in: &cancellables)
    }

    
    private func checkAndUpdateAchievementsIfLoaded() {
        guard initialUserLoadCompleted else { return }
        checkAndUpdateAchievements()
    }
    
    func loadAchievements() {
        guard let user = userDiscViewModel.user else {
            // Wait until the user is fully loaded
            print("User not loaded. Achievements cannot be loaded yet.")
            return
        }
        
        // Get base achievements and user's earned achievements
        let baseAchievements = AchievementDataManager.shared.achievements
        let earnedAchievementIDs = Set(user.earnedAchievements)
        
        // Map achievements and set `isEarned` based on user's earnedAchievements
        achievements = baseAchievements.map { achievement in
            var updated = achievement
            if earnedAchievementIDs.contains(achievement.id.uuidString) {
                updated.isEarned = true
            }
            return updated
        }
    }

    
    private func checkAndUpdateAchievements() {
        guard let user = userDiscViewModel.user else {
            print("User not loaded. Cannot check achievements.")
            return
        }
        
        var newlyEarned: [Achievement] = []
        
        for i in 0..<achievements.count {
            let achievement = achievements[i]
            // Skip already earned achievements
            if achievement.isEarned { continue }
            
            // Check if the achievement is now earned
            if isAchievementEarned(achievement) {
                achievements[i].isEarned = true
                newlyEarned.append(achievements[i])
            }
        }
        
        // If new achievements are earned, save and award points
        if !newlyEarned.isEmpty {
            saveEarnedAchievements(newlyEarned.map { $0.id }) { [weak self] success in
                guard success, let self = self else { return }
                self.awardAchievements(newlyEarned)
            }
        }
    }

    
    private func isAchievementEarned(_ achievement: Achievement) -> Bool {
        let discCount = discCatalogViewModel.discCount
        let discPoints = userDiscViewModel.discPoints
        let favorites = discCatalogViewModel.favoriteCount
        
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
    
    private func saveEarnedAchievements(_ newAchievementIDs: [UUID], completion: @escaping (Bool) -> Void) {
        guard var user = userDiscViewModel.user else {
            completion(false)
            return
        }

        let newAchievementIDStrings = newAchievementIDs.map { $0.uuidString }
        user.earnedAchievements.append(contentsOf: newAchievementIDStrings)
        user.earnedAchievements = Array(Set(user.earnedAchievements))
        
        userDiscViewModel.user = user
        userDiscViewModel.saveUserToFirestore { success in
            completion(success)
        }
    }

    private func awardAchievements(_ achievementsToAward: [Achievement]) {
        // Award points for newly earned achievements once
        let totalPoints = achievementsToAward.reduce(0) { $0 + $1.points }
        userDiscViewModel.addDiscPoints(totalPoints)
        // No further checks here to prevent loops
        // Achievements won't re-trigger since they're now marked as earned
    }
}
