//
//  DiscDetailView.swift
//  DiscTracker
//
//  Created by Asher Antrim on 9/11/24.
//
import SwiftUI

struct DiscDetailView: View {
    var disc: Disc

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let imageData = disc.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(Circle())
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(Circle())
            }

            Text(disc.name)
                .font(.largeTitle)
                .bold()

            Text("Type: \(disc.type)")
            Text("Plastic: \(disc.plasticType)")
            Text("Condition: \(disc.condition)")
            
            if disc.lost {
                Text("Status: Lost").foregroundColor(.red)
            } else {
                Text("Status: In Bag").foregroundColor(.green)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Disc Details")
    }
}


