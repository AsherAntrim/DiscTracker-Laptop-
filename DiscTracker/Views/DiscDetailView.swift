//
//  DiscDetailView.swift
//  DiscTracker
//
//  Created by Asher Antrim on 9/11/24.
//

import SwiftUI
import FirebaseAuth

/// View displaying the details of a specific disc.
struct DiscDetailView: View {
    @ObservedObject var userDiscViewModel: UserDiscViewModel
    @ObservedObject var discCatalogViewModel: DiscCatalogViewModel
    @Binding var disc: Disc

    var body: some View {
        ZStack {
            // Green background
            Theme.backgroundColor
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                // Disc Information
                VStack(spacing: 16) {
                    Text("Disc Details")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.primaryTextColor)
                        .padding(.top, 20)

                    VStack(alignment: .leading, spacing: 10) {
                        DiscInfoRow(title: "Name", value: disc.name)
                        DiscInfoRow(title: "Type", value: disc.type)
                        DiscInfoRow(title: "Plastic Type", value: disc.plasticType)
                        DiscInfoRow(title: "Condition", value: disc.condition)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 4)
                    )
                }
                .padding(.horizontal)

                // Toggle Options
                VStack(spacing: 16) {
                    ToggleOptionRow(title: "Mark as Lost", isOn: Binding(
                        get: { disc.lost },
                        set: { newValue in
                            disc.lost = newValue
                            discCatalogViewModel.updateDiscStatus(disc: disc, userId: Auth.auth().currentUser?.uid ?? "")
                        }
                    ))

                    ToggleOptionRow(title: "Mark as Traded", isOn: Binding(
                        get: { disc.traded },
                        set: { newValue in
                            disc.traded = newValue
                            discCatalogViewModel.updateDiscStatus(disc: disc, userId: Auth.auth().currentUser?.uid ?? "")
                        }
                    ))
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
        }
        .navigationBarTitle("\(disc.name) - \(disc.type)", displayMode: .inline) // Updated title
    }
}

/// Custom row for displaying disc information.
struct DiscInfoRow: View {
    var title: String
    var value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(Theme.primaryTextColor) // Changed to black for visibility
            Spacer()
            Text(value)
                .font(.body)
                .foregroundColor(Theme.primaryTextColor) // Changed to gray for value contrast
        }
        .padding(.vertical, 5)
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 4)
        )
    }
}
/// Custom row for toggle options.
struct ToggleOptionRow: View {
    var title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(Theme.primaryTextColor)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: Theme.highlightColor)) // Custom toggle style
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 4)
        )
    }
}
