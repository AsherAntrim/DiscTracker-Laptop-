//
//  DiscCatalogView.swift
//  DiscTracker
//
//  Created by Asher Antrim on 9/11/24.
//

import SwiftUI

/// The main view displaying the catalog of discs.
struct DiscCatalogView: View {
    @StateObject private var viewModel = DiscCatalogViewModel()
    @State private var showAddDiscSheet = false
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
    
    /// The search bar for filtering discs.
    private var searchBar: some View {
        TextField("Search discs", text: $searchText)
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)
    }
    
    /// The list displaying all filtered and sorted discs.
    private var discList: some View {
        VStack {
            searchBar
            List {
                ForEach(viewModel.getFilteredAndSortedDiscs(searchText: searchText), id: \.id) { disc in
                    NavigationLink(
                        destination: DiscDetailView(disc: binding(for: disc))
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
    
    /// Provides a binding for the given disc to allow for data updates.
    ///
    /// - Parameter disc: The disc to create a binding for.
    /// - Returns: A binding to the disc within the discs array.
    private func binding(for disc: Disc) -> Binding<Disc> {
        guard let discIndex = viewModel.discs.firstIndex(where: { $0.id == disc.id }) else {
            fatalError("Disc not found in the array")
        }
        return $viewModel.discs[discIndex]
    }
    
    /// The button to add a new disc.
    private var addButton: some View {
        Button(action: { showAddDiscSheet.toggle() }) {
            Image(systemName: "plus")
                .foregroundStyle(.white)
        }
    }
    
    /// Deletes a disc at the specified offsets.
    ///
    /// - Parameter offsets: The index set of discs to delete.
    private func deleteDisc(at offsets: IndexSet) {
        viewModel.removeDisc(at: offsets)
    }
}

#Preview {
    DiscCatalogView()
}
