//
//  DiscDetailView.swift
//  DiscTracker
//
//  Created by Asher Antrim on 9/11/24.
//


import SwiftUI

/// View displaying the details of a specific disc.
struct DiscDetailView: View {
    @ObservedObject var userDiscViewModel: UserDiscViewModel
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
                Toggle("Lost", isOn: $disc.lost)
                    .onChange(of: disc.lost) { oldValue, newValue in
                        if newValue {
                            userDiscViewModel.removeDiscPoints(5)
                        }
                    }

                Toggle("Traded", isOn: $disc.traded)
                    .onChange(of: disc.traded) { oldValue, newValue in
                        if newValue {
                            userDiscViewModel.removeDiscPoints(5)
                        }
                    }
            }
        }
        .navigationBarTitle(disc.name, displayMode: .inline)
    }
}
