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
            .compactMap { $0 } // Only proceed when user is not nil
            .first()           // Only handle the first time the user loads
            .sink { [weak self] _ in
                self?.loadAchievements()
                self?.initialUserLoadCompleted = true
            }
            .store(in: &cancellables)

        // Check achievements only when conditions change:
        // After initial load is done
        discCatalogViewModel.$discCount
            .drop(untilOutputFrom: userDiscViewModel.$user.compactMap { $0 }.first())
            .sink { [weak self] _ in self?.checkAndUpdateAchievementsIfLoaded() }
            .store(in: &cancellables)
        
        discCatalogViewModel.$favoriteCount
            .drop(untilOutputFrom: userDiscViewModel.$user.compactMap { $0 }.first())
            .sink { [weak self] _ in self?.checkAndUpdateAchievementsIfLoaded() }
            .store(in: &cancellables)
    }
    
    private func checkAndUpdateAchievementsIfLoaded() {
        guard initialUserLoadCompleted else { return }
        checkAndUpdateAchievements()
    }
    
    func loadAchievements() {
        let baseAchievements = AchievementDataManager.shared.achievements
        let earnedAchievementIDs = (userDiscViewModel.user?.earnedAchievements ?? []).filter { !$0.isEmpty }
        
        achievements = baseAchievements.map { achievement in
            var updated = achievement
            if earnedAchievementIDs.contains(updated.id.uuidString) {
                updated.isEarned = true
            }
            return updated
        }
        
        // Optionally call check once after load, if needed:
        checkAndUpdateAchievements()
    }
    
    private func checkAndUpdateAchievements() {
        guard let user = userDiscViewModel.user else {
            return
        }
        
        var newlyEarned: [Achievement] = []
        // Check which are newly earned
        for i in 0..<achievements.count {
            let achievement = achievements[i]
            if !achievement.isEarned && isAchievementEarned(achievement) {
                achievements[i].isEarned = true
                newlyEarned.append(achievements[i])
            }
        }

        // If newly earned, first save them, then award points:
        if !newlyEarned.isEmpty {
            saveEarnedAchievements(newlyEarned.map { $0.id }) { [weak self] success in
                guard success, let self = self else { return }
                // Now award points (only once)
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
