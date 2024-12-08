//
//  AchievementsView.swift
//  DiscTracker
//
//  Created by Nathan Hollis on 12/4/24.
//

import SwiftUI

struct AchievementsView: View {
    @ObservedObject var userDiscViewModel: UserDiscViewModel
    @ObservedObject var discCatalogViewModel: DiscCatalogViewModel
    @StateObject private var achievementViewModel: AchievementViewModel

    init(userDiscViewModel: UserDiscViewModel, discCatalogViewModel: DiscCatalogViewModel) {
        self.userDiscViewModel = userDiscViewModel
        self.discCatalogViewModel = discCatalogViewModel
        _achievementViewModel = StateObject(wrappedValue: AchievementViewModel(
            userDiscViewModel: userDiscViewModel,
            discCatalogViewModel: discCatalogViewModel
        ))
    }

    let backgroundColor = Color(red: 34 / 255, green: 139 / 255, blue: 34 / 255)

    var body: some View {
        NavigationView {
            List {
                ForEach(achievementViewModel.achievements) { achievement in
                    AchievementRowView(achievement: achievement)
                }
            }
            .scrollContentBackground(.hidden)
            .background(backgroundColor.edgesIgnoringSafeArea(.all))
            .navigationTitle("Achievements")
            .onAppear {
                achievementViewModel.loadAchievements()
            }
        }
    }
}

struct AchievementRowView: View {
    let achievement: Achievement

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.headline)
                    .foregroundColor(.black)
                Text(achievement.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()

            // Checkmark icon if achievement is earned
            if achievement.isEarned {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            } else {
                Image(systemName: "circle")
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 4)
    }
}
