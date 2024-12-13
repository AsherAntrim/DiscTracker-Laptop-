//
//  DiscDetailView.swift
//  DiscTracker
//
//  Created by Asher Antrim on 9/11/24.
//  Modified by OpenAI on 12/09/24.
//

import SwiftUI
import FirebaseAuth

struct DiscDetailView: View {
    @ObservedObject var userDiscViewModel: UserDiscViewModel
    @ObservedObject var discCatalogViewModel: DiscCatalogViewModel
    @Binding var disc: Disc

    var body: some View {
        ZStack {
            Theme.backgroundColor.edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
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
                    DiscInfoRow(title: "Speed", value: "\(disc.speed)")
                    DiscInfoRow(title: "Glide", value: "\(disc.glide)")
                    DiscInfoRow(title: "Turn", value: "\(disc.turn)")
                    DiscInfoRow(title: "Fade", value: "\(disc.fade)")
                }

                VStack(spacing: 16) {
                    ToggleOptionRow(
                        title: "Mark as Lost",
                        isOn: Binding(
                            get: { disc.lost },
                            set: { newValue in
                                disc.lost = newValue
                                updateDisc(disc)
                            }
                        )
                    )

                    ToggleOptionRow(
                        title: "Favorite",
                        isOn: Binding(
                            get: { disc.favorite },
                            set: { newValue in
                                disc.favorite = newValue
                                updateDisc(disc)
                            }
                        )
                    )
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
        }
        .navigationBarTitle("\(disc.name) - \(disc.type)", displayMode: .inline)
    }

    private func updateDisc(_ disc: Disc) {
        if let userId = Auth.auth().currentUser?.uid {
            discCatalogViewModel.updateDiscStatus(disc: disc, userId: userId)
        }
    }
}

struct DiscInfoRow: View {
    var title: String
    var value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary) // dynamic text color
            Spacer()
            Text(value)
                .font(.body)
                .foregroundColor(.primary) // dynamic text color
        }
        .padding(.vertical, 5)
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.secondarySystemBackground)) // dynamic background
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 4)
        )
    }
}

struct ToggleOptionRow: View {
    var title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary) // dynamic text color
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: Theme.highlightColor))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.secondarySystemBackground)) // dynamic background
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 4)
        )
    }
}
