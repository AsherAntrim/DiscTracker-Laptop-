//
//  DiscCatalogView.swift
//  DiscTracker
//
//  Created by Asher Antrim on 9/11/24.
//

import SwiftUI
import FirebaseAuth

/// The main view displaying the catalog of discs and account info.
struct DiscCatalogView: View {
    @StateObject private var discCatalogViewModel = DiscCatalogViewModel()
    @State private var userDiscViewModel = UserDiscViewModel()
    @State private var showAddDiscSheet = false
    @State private var searchText = ""
    @State private var isUserAuthenticated = false // Track authentication status
    @State private var authStateListenerHandle: AuthStateDidChangeListenerHandle? // Firebase auth listener
    @State private var showAlert = false
    @State private var discPoints = 0
    
    // DiscTracker-themed colors
    let backgroundColor = Color(red: 34/255, green: 139/255, blue: 34/255) // Green for outdoors
    let accentColor = Color(red: 60/255, green: 70/255, blue: 80/255) // Neutral accent
    let highlightColor = Color(red: 255/255, green: 165/255, blue: 0/255) // Orange for highlights

    init() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }

    var body: some View {
        Group {
            if isUserAuthenticated {
                mainTabView
            } else {
                AuthView() // Show authentication view
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
            
            AchievementsView(userDiscViewModel: userDiscViewModel)
                .tabItem {
                    Label("Achievements", systemImage: "medal")
                }
            
            AccountView(userDiscViewModel: userDiscViewModel)
                .tabItem {
                    Label("Account", systemImage: "person.circle")
                }
        }
    }

    /// The Disc Catalog tab.
    private var discCatalogTab: some View {
        NavigationView {
            VStack {
                discList
            }
            .navigationTitle("Disc Catalog")
            .navigationBarItems(trailing: addButton)
            .sheet(isPresented: $showAddDiscSheet) {
                AddDiscView(discCatalogViewModel: discCatalogViewModel, showAlert: $showAlert)
            }

            .background(backgroundColor.edgesIgnoringSafeArea(.all)) // Green background
        }
        .onAppear { discCatalogViewModel.loadDiscs() }
    }
    
    private func loadDiscPoints() {
        userDiscViewModel.loadUser { points in
            self.discPoints = points
        }
    }

    /// The Account tab.
    private var accountTab: some View {
        AccountView(userDiscViewModel: userDiscViewModel)
    }

    /// The search bar for filtering discs.
    private var searchBar: some View {
        TextField("Search discs", text: $searchText)
            .padding(10)
            .background(accentColor.opacity(0.2)) // Neutral background for text input
            .cornerRadius(8)
            .padding(.horizontal)
    }

    /// The list displaying all filtered discs.
    private var discList: some View {
        VStack {
            searchBar
            List {
                ForEach(filteredDiscs, id: \.id) { disc in
                    NavigationLink(
                        destination: DiscDetailView(userDiscViewModel: userDiscViewModel, disc: binding(for: disc))
                    ) {
                        VStack(alignment: .leading) {
                            Text(disc.name)
                                .font(.headline)
                                .foregroundColor(highlightColor) // Orange highlight for disc name
                            Text("\(disc.type) | \(disc.plasticType)")
                                .font(.subheadline)
                                .foregroundColor(.white) // White text for details
                        }
                    }
                }
                .onDelete(perform: deleteDisc)
            }
            .listStyle(InsetGroupedListStyle())
            .background(backgroundColor) // Green background for the list
        }
    }

    private func binding(for disc: Disc) -> Binding<Disc> {
        guard let discIndex = discCatalogViewModel.discs.firstIndex(where: { $0.id == disc.id }) else {
            fatalError("Disc not found in the array")
        }
        return $discCatalogViewModel.discs[discIndex]
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

    /// The button to add a new disc.
    private var addButton: some View {
        Button(action: { showAddDiscSheet.toggle() }) {
            Image(systemName: "plus")
                .foregroundColor(.white)
                .padding()
                .background(highlightColor) // Orange background
                .clipShape(Circle())
                .shadow(radius: 5) // Adds depth to the button
        }
    }

    /// Deletes a disc at the specified offsets.
    private func deleteDisc(at offsets: IndexSet) {
        discCatalogViewModel.removeDisc(at: offsets)
    }

    /// Set up Firebase authentication listener
    private func setupAuthListener() {
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { _, user in
            isUserAuthenticated = (user != nil)
        }
    }

    /// Remove Firebase authentication listener
    private func removeAuthListener() {
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}

#Preview {
    DiscCatalogView()
}
