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
        }
    var body: some Scene {
        WindowGroup {
            DiscCatalogView()
        }
    }
}


