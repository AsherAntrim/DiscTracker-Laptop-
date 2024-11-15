//
//  ContentView.swift
//  DiscTracker
//
//  Created by Asher Antrim on 9/11/24.
//

import SwiftUI

struct DiscCatalogView: View {
    @StateObject private var viewModel = DiscCatalogViewModel()
    @State private var showAddDiscSheet = false
    @State private var sortType: SortType = .name
    @State private var searchText = ""
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    var body: some View {
        NavigationView {
            VStack {
                discList
            }
            .navigationTitle("Disc Catalog")
            .navigationBarItems(trailing: addButton)
            .sheet(isPresented: $showAddDiscSheet) {
                AddDiscView(viewModel: viewModel)
            }
            .background(Color.blue)
        }
        .onAppear { viewModel.loadDiscs() }
    }

    private var searchBar: some View {
            TextField("Search discs", text: $searchText)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
        }
    
    private var discList: some View {
        VStack() {
            searchBar
            List {
                ForEach(filteredDiscs, id: \.id) { disc in
                    NavigationLink(
                        destination: DiscDetailView(disc: Binding(
                            get: { viewModel.discs.first(where: { $0.id == disc.id }) ?? disc },
                            set: { newValue in
                                if let index = viewModel.discs.firstIndex(where: { $0.id == disc.id }) {
                                    viewModel.discs[index] = newValue
                                }
                            }
                        ))
                    ) {
                        VStack(alignment: .leading) {
                            Text(disc.name).font(.headline)
                            Text("\(disc.type) | \(disc.plasticType)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteDisc)
            }
            .listStyle(InsetGroupedListStyle())
        }
    }

    
    private var filteredDiscs: [Disc] {
        if searchText.isEmpty {
            return viewModel.discs
        } else {
            return viewModel.discs.filter { disc in
                disc.name.localizedCaseInsensitiveContains(searchText) ||
                disc.type.localizedCaseInsensitiveContains(searchText) ||
                disc.plasticType.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private var addButton: some View {
        Button(action: { showAddDiscSheet.toggle() }) {
            Image(systemName: "plus")
                .foregroundStyle(.white)
        }
    }
    
    private func deleteDisc(at offsets: IndexSet) {
        viewModel.removeDisc(at: offsets)
    }
}


#Preview {
    DiscCatalogView()
}
