import Foundation

class DiscCatalogViewModel: ObservableObject {
    @Published var discs: [Disc] = []

    func addDisc(name: String, type: String, plasticType: String, condition: String, imageData: Data?) {
        let newDisc = Disc(name: name, type: type, plasticType: plasticType, condition: condition, imageData: imageData)
        discs.append(newDisc)
        saveDiscs()
    }

    func removeDisc(at offsets: IndexSet) {
        discs.remove(atOffsets: offsets)
        saveDiscs()
    }

    func saveDiscs() {
        if let encoded = try? JSONEncoder().encode(discs) {
            UserDefaults.standard.set(encoded, forKey: "savedDiscs")
        }
    }

    func loadDiscs() {
        if let savedDiscs = UserDefaults.standard.data(forKey: "savedDiscs"),
           let decoded = try? JSONDecoder().decode([Disc].self, from: savedDiscs) {
            discs = decoded
        }
    }
}
