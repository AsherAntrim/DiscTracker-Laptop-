//
//  ContentView.swift
//  DiscTracker
//
//  Created by Asher Antrim on 9/11/24.
//

import SwiftUI

struct DiscCatalogView: View {
    @StateObject var viewModel = DiscCatalogViewModel()
    @State private var showAddDiscSheet = false
    @State private var sortType: SortType = .name
    
    init() {
            let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
        }

    var sortedDiscs: [Disc] {
        switch sortType {
        case .name:
            return viewModel.discs.sorted { $0.name < $1.name }
        case .type:
            return viewModel.discs.sorted { $0.type < $1.type }
        case .plastic:
            return viewModel.discs.sorted { $0.plasticType < $1.plasticType }
        case .condition:
            return viewModel.discs.sorted { $0.condition < $1.condition }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Picker("Sort By", selection: $sortType) {
                    Text("Name").tag(SortType.name)
                    Text("Type").tag(SortType.type)
                    Text("Plastic").tag(SortType.plastic)
                    Text("Condition").tag(SortType.condition)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                List {
                    ForEach(sortedDiscs) { disc in
                        NavigationLink(destination: DiscDetailView(disc: disc)) {
                            HStack {
                                if let imageData = disc.imageData, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                }
                                VStack(alignment: .leading) {
                                    Text(disc.name).font(.headline)
                                    Text("\(disc.type) | \(disc.plasticType)")
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteDisc)
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("Disc Catalog")
            .navigationBarItems(trailing: Button(action: {
                showAddDiscSheet = true
            }, label: {
                Image(systemName: "plus")
                    .foregroundStyle(.white)
            }))
            .sheet(isPresented: $showAddDiscSheet, content: {
                AddDiscView(viewModel: viewModel)
            })
            .background(Color.blue)
        }
        .onAppear {
            viewModel.loadDiscs()
            
        }
    }

    // Function to handle disc deletion
    func deleteDisc(at offsets: IndexSet) {
        viewModel.removeDisc(at: offsets)
    }
}

enum SortType {
    case name, type, plastic, condition
}



#Preview {
    DiscCatalogView()
}
