//
//  DiscCatalogView.swift
//  DiscTracker
//
//  Created by Asher Antrim on 9/11/24.
//  Modified by OpenAI on 12/09/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

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

    private var mainTabView: some View {
        TabView {
            discCatalogTab
                .tabItem {
                    Label("Discs", systemImage: "tray.full")
                }

            RecommendationView(discCatalogViewModel: discCatalogViewModel)
                .tabItem {
                    Label("Recommendation", systemImage: "star")
                }

            AchievementsView(userDiscViewModel: userDiscViewModel, discCatalogViewModel: discCatalogViewModel)
                .tabItem {
                    Label("Achievements", systemImage: "medal")
                }

            AccountView(userDiscViewModel: userDiscViewModel)
                .tabItem {
                    Label("Account", systemImage: "person.circle")
                }
        }
        .accentColor(Theme.highlightColor)
    }

    private var discCatalogTab: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    Spacer()
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
                                            if disc.favorite {
                                                Image(systemName: "heart.fill").foregroundColor(.red)
                                            }
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
                .background(Theme.backgroundColor)

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

    private var searchBar: some View {
        TextField("Search discs", text: $searchText)
            .padding(10)
            .background(Theme.accentColor.opacity(0.2))
            .cornerRadius(8)
            .padding(.horizontal)
    }

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

    private func setupAuthListener() {
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { _, user in
            isUserAuthenticated = (user != nil)
            if isUserAuthenticated {
                discCatalogViewModel.loadDiscs()
                userDiscViewModel.loadUser()
            }
        }
    }

    private func removeAuthListener() {
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
