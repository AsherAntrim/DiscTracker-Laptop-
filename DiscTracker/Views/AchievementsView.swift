//
//  AchievementsView.swift
//  DiscTracker
//
//  Created by Nathan Hollis on 12/4/24.
//  Modified by OpenAI on 12/09/24.
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

    var body: some View {
        NavigationView {
            List {
                ForEach(achievementViewModel.achievements) { achievement in
                    AchievementRowView(achievement: achievement)
                        .listRowBackground(Theme.accentColor.opacity(0.1))
                }
            }
            .scrollContentBackground(.hidden)
            .background(Theme.backgroundColor.edgesIgnoringSafeArea(.all))
            .navigationTitle("Achievements")
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
                    .foregroundColor(Theme.primaryTextColor)
                Text(achievement.description)
                    .font(.subheadline)
                    .foregroundColor(Theme.secondaryTextColor)
                Text("Reward: \(achievement.points)")
                    .font(.footnote)
                    .foregroundColor(Theme.primaryTextColor)
            }
            Spacer()
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
