//
//  Theme.swift
//  DiscTracker
//
//  Created by Asher Antrim on 12/4/24.
//
//  A refreshed color scheme: Dark background with vibrant highlight color.
//

import SwiftUI

struct Theme {
    static let backgroundColor = Color(UIColor.systemBackground) // Adapts to light/dark mode
    static let accentColor = Color.accentColor // System accent color
    static let highlightColor = Color.yellow // Gold color remains consistent
    static let primaryTextColor = Color.primary // Adapts to light/dark mode
    static let secondaryTextColor = Color.secondary // Adapts to light/dark mode
}
