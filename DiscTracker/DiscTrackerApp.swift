//
//  DiscTrackerApp.swift
//  DiscTracker
//
//  Created by Asher Antrim on 9/11/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore


@main
struct DiscGolfApp: App {
    init() {
            FirebaseApp.configure()
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(Theme.backgroundColor)
            appearance.titleTextAttributes = [.foregroundColor: UIColor(Theme.primaryTextColor)]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Theme.primaryTextColor)]

            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    var body: some Scene {
        WindowGroup {
            DiscCatalogView()
        }
    }
}


