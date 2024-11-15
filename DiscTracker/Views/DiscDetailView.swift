import SwiftUI

struct DiscDetailView: View {
    @Binding var disc: Disc

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

            Toggle("Lost", isOn: $disc.lost)
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(8)

            Spacer()
        }
        .padding()
        .navigationTitle("Disc Details")
    }
}
