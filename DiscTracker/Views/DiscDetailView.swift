//
//  DiscDetailView.swift
//  DiscTracker
//
//  Created by Asher Antrim on 9/11/24.
//

import SwiftUI

/// View displaying the details of a specific disc.
struct DiscDetailView: View {
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
                Toggle("Traded", isOn: $disc.traded)
            }
            // Additional UI for displaying the image can be added here
        }
        .navigationBarTitle(disc.name, displayMode: .inline)
    }
}

#Preview {
    DiscDetailView(disc: .constant(Disc(name: "Sample Disc", type: "Driver", plasticType: "Champion", condition: "New")))
}
