import Foundation

class DiscCatalogViewModel: ObservableObject {
    @Published var discs: [Disc] = []
    @Published var sortType: SortType = .name
    
    private let userDefaultsKey = "savedDiscs"

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
        do {
            let encodedData = try JSONEncoder().encode(discs)
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
        } catch {
            print("Failed to save discs: \(error.localizedDescription)")
        }
    }

    func loadDiscs() {
        guard let savedData = UserDefaults.standard.data(forKey: userDefaultsKey) else { return }
        do {
            discs = try JSONDecoder().decode([Disc].self, from: savedData)
        } catch {
            print("Failed to load discs: \(error.localizedDescription)")
        }
    }
    
    var sortedDiscs: [Disc] {
            switch sortType {
            case .name:
                return discs.sorted { $0.name < $1.name }
            case .type:
                return discs.sorted { $0.type < $1.type }
            case .plastic:
                return discs.sorted { $0.plasticType < $1.plasticType }
            case .condition:
                return discs.sorted { $0.condition < $1.condition }
            case .lost:
                return discs.filter { $0.lost }
            case .traded:
                return discs.filter { $0.traded }
            }
        }
}
