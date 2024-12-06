//
//  AchievementsView.swift
//  DiscTracker
//
//  Created by Nathan Hollis on 12/4/24.
//

import SwiftUI

struct AchievementsView: View {
    @ObservedObject var userDiscViewModel: UserDiscViewModel

    let backgroundColor = Color(red: 34/255, green: 139/255, blue: 34/255) // Green background color

    private let achievements: [Achievement] = [
        Achievement(title: "First Disc", description: "Catalog your first disc", points: 10),
        Achievement(title: "Disc Enthusiast", description: "Catalog 10 discs", points: 50),
        Achievement(title: "Disc Collector", description: "Catalog 25 discs", points: 100),
        Achievement(title: "Disc Connoisseur", description: "Catalog 50 discs", points: 250),
        Achievement(title: "Disc Master", description: "Catalog 100 discs", points: 500)
    ]

    var body: some View {
        NavigationView {
            List {
                ForEach(achievements) { achievement in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(achievement.title)
                                .font(.headline)
                                .foregroundColor(.black) // Default text color
                            Text(achievement.description)
                                .font(.subheadline)
                                .foregroundColor(.gray) // Default description color
                            Text("Max Discs Cataloged: \(userDiscViewModel.getMaxDiscsCataloged)")
                        }
                        Spacer()
                        if isAchievementEarned(achievement: achievement) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "circle")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden) // Ensures List content uses the background
            .background(backgroundColor.edgesIgnoringSafeArea(.all)) // Green background
            .navigationTitle("Achievements")
        }
    }

    private func isAchievementEarned(achievement: Achievement) -> Bool {
        guard let user = userDiscViewModel.user else { return false }
        switch achievement.title {
        case "First Disc":
            return user.maxDiscsCataloged >= 1
        case "Disc Enthusiast":
            return user.maxDiscsCataloged >= 10
        case "Disc Collector":
            return user.maxDiscsCataloged >= 25
        case "Disc Connoisseur":
            return user.maxDiscsCataloged >= 50
        case "Disc Master":
            return user.maxDiscsCataloged >= 100
        default:
            return false
        }
    }
}
