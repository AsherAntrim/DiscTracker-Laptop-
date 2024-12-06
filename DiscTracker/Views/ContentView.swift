//
//  DiscCatalogView.swift
//  DiscTracker
//
//  Created by Asher Antrim on 9/11/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

/// The main view displaying the catalog of discs and account info.
struct DiscCatalogView: View {
    @StateObject private var discCatalogViewModel = DiscCatalogViewModel()
    @StateObject private var userDiscViewModel = UserDiscViewModel()
    @State private var showAddDiscSheet = false
    @State private var searchText = ""
    @State private var isUserAuthenticated = false
    @State private var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    @State private var showAlert = false

    var body: some View {
        Group {
            if isUserAuthenticated {
                mainTabView
            } else {
                AuthView()
            }
        }
        .onAppear {
            setupAuthListener()
        }
        .onDisappear {
            removeAuthListener()
        }
    }

    /// The tab view containing Disc Catalog and Account tabs.
    private var mainTabView: some View {
        TabView {
            discCatalogTab
                .tabItem {
                    Label("Discs", systemImage: "tray.full")
                }

            AccountView(userDiscViewModel: userDiscViewModel)
                .tabItem {
                    Label("Account", systemImage: "person.circle")
                }
        }
        .accentColor(Theme.highlightColor)
    }

    /// The Disc Catalog tab.
    private var discCatalogTab: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    searchBar
                    if discCatalogViewModel.discs.isEmpty {
                        Spacer()
                        Text("No discs available.")
                            .foregroundColor(Theme.secondaryTextColor)
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(spacing: 10) {
                                ForEach(filteredDiscs, id: \.id) { disc in
                                    NavigationLink(
                                        destination: DiscDetailView(
                                            userDiscViewModel: userDiscViewModel,
                                            discCatalogViewModel: discCatalogViewModel,
                                            disc: binding(for: disc)
                                        )
                                    ) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(disc.name)
                                                    .font(.headline)
                                                    .foregroundColor(.primary)
                                                Text("\(disc.type) | \(disc.plasticType)")
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                
                                            }
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.gray)
                                        }
                                        .padding()
                                        .background(Color(UIColor.secondarySystemBackground))
                                        .cornerRadius(10)
                                        .shadow(radius: 1)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.top)
                        }
                    }
                }
                .background(Theme.backgroundColor.edgesIgnoringSafeArea(.all))

                // Add Disc Button
                Button(action: { showAddDiscSheet.toggle() }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Theme.primaryTextColor)
                        .padding()
                        .background(Theme.highlightColor)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .padding()
                .sheet(isPresented: $showAddDiscSheet) {
                    AddDiscView(discCatalogViewModel: discCatalogViewModel, showAlert: $showAlert)
                }
            }
            .navigationTitle("Disc Catalog")
            .onAppear { discCatalogViewModel.loadDiscs() }
        }
    }

    /// The search bar for filtering discs.
    private var searchBar: some View {
        TextField("Search discs", text: $searchText)
            .padding(10)
            .background(Theme.accentColor.opacity(0.2))
            .cornerRadius(8)
            .padding(.horizontal)
    }

    /// The list of discs filtered based on the search text.
    private var filteredDiscs: [Disc] {
        if searchText.isEmpty {
            return discCatalogViewModel.discs
        } else {
            return discCatalogViewModel.discs.filter { disc in
                disc.name.localizedCaseInsensitiveContains(searchText) ||
                disc.type.localizedCaseInsensitiveContains(searchText) ||
                disc.plasticType.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    private func binding(for disc: Disc) -> Binding<Disc> {
        guard let discIndex = discCatalogViewModel.discs.firstIndex(where: { $0.id == disc.id }) else {
            fatalError("Disc not found in the array")
        }
        return $discCatalogViewModel.discs[discIndex]
    }

    /// Deletes a disc at the specified offsets.
    private func deleteDisc(at offsets: IndexSet) {
        discCatalogViewModel.removeDisc(at: offsets)
    }

    /// Set up Firebase authentication listener
    private func setupAuthListener() {
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { _, user in
            isUserAuthenticated = (user != nil)
            if isUserAuthenticated {
                discCatalogViewModel.loadDiscs()
                userDiscViewModel.loadUser()
            }
        }
    }

    /// Remove Firebase authentication listener
    private func removeAuthListener() {
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}

struct DiscCatalogView_Previews: PreviewProvider {
    static var previews: some View {
        DiscCatalogView()
    }
}
