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
        Form {
            Section(header: Text("Disc Information")) {
                Text("Name: \(disc.name)")
                Text("Type: \(disc.type)")
                Text("Plastic Type: \(disc.plasticType)")
                Text("Condition: \(disc.condition)")
            }
            Section {
                Toggle("Mark as Lost", isOn: Binding(
                    get: { disc.lost },
                    set: { newValue in
                        disc.lost = newValue
                        discCatalogViewModel.updateDiscStatus(disc: disc, userId: Auth.auth().currentUser?.uid ?? "")
                    }
                ))
                .toggleStyle(SwitchToggleStyle())

                Toggle("Mark as Traded", isOn: Binding(
                    get: { disc.traded },
                    set: { newValue in
                        disc.traded = newValue
                        discCatalogViewModel.updateDiscStatus(disc: disc, userId: Auth.auth().currentUser?.uid ?? "")
                    }
                ))
                .toggleStyle(SwitchToggleStyle())
            }
        }
        .navigationBarTitle(disc.name, displayMode: .inline)
    }
}
