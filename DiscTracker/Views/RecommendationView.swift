//
//  RecommendationView.swift
//  DiscTracker
//
//  Modified by OpenAI on 12/09/24.
//

import SwiftUI

struct RecommendationView: View {
    @ObservedObject var discCatalogViewModel: DiscCatalogViewModel
    
    // Stability options for the picker
    private let stabilityOptions = ["Overstable", "Understable", "Stable"]
    @State private var selectedStabilityIndex = 0
    
    // Distance options for the picker
    private let distanceOptions = [50, 100, 150, 200, 250, 300, 350, 400, 450, 500]
    @State private var selectedDistanceIndex = 0
    
    @State private var recommendedDisc: Disc?
    @State private var showNoDiscMessage = false
    @State private var showErrorAlert = false
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(gradient: Gradient(colors: [Theme.backgroundColor, Theme.accentColor]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Text("Recommend a Disc")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.highlightColor)
                    .padding(.top, 40)
                
                // Pickers Section
                HStack(spacing: 20) {
                    VStack {
                        Text("Stability")
                            .font(.headline)
                            .foregroundColor(Theme.primaryTextColor)
                        Picker("Stability", selection: $selectedStabilityIndex) {
                            ForEach(0..<stabilityOptions.count, id: \.self) { index in
                                Text(stabilityOptions[index])
                                    .foregroundColor(Theme.primaryTextColor)
                                    .tag(index)
                            }
                        }
                        .frame(width: 150, height: 150)
                        .clipped()
                        .pickerStyle(WheelPickerStyle())
                        .background(Theme.accentColor.opacity(0.2))
                        .cornerRadius(12)
                    }
                    
                    VStack {
                        Text("Distance (ft)")
                            .font(.headline)
                            .foregroundColor(Theme.primaryTextColor)
                        Picker("Distance", selection: $selectedDistanceIndex) {
                            ForEach(0..<distanceOptions.count, id: \.self) { index in
                                Text("\(distanceOptions[index])")
                                    .foregroundColor(Theme.primaryTextColor)
                                    .tag(index)
                            }
                        }
                        .frame(width: 150, height: 150)
                        .clipped()
                        .pickerStyle(WheelPickerStyle())
                        .background(Theme.accentColor.opacity(0.2))
                        .cornerRadius(12)
                    }
                }
                
                // Get Recommendation Button
                Button(action: getRecommendation) {
                    Text("Get Recommendation")
                        .font(.headline)
                        .foregroundColor(Theme.primaryTextColor)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Theme.highlightColor)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
                
                // Recommended Disc Display
                if let disc = recommendedDisc {
                    VStack(spacing: 16) {
                        Text("Recommended Disc")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.primaryTextColor)
                        
                        // Disc Card
                        VStack(spacing: 12) {
                            // Displaying disc name and type
                            Text("\(disc.name) - \(disc.type)")
                                .font(.headline)
                                .foregroundColor(Theme.primaryTextColor)
                            
                            Text("\(disc.plasticType), \(disc.condition)")
                                .font(.subheadline)
                                .foregroundColor(Theme.secondaryTextColor)
                            
                            // Flight numbers row
                            HStack(spacing: 20) {
                                FlightNumberView(label: "SPD", value: disc.speed)
                                FlightNumberView(label: "GLD", value: disc.glide)
                                FlightNumberView(label: "TRN", value: disc.turn)
                                FlightNumberView(label: "FDE", value: disc.fade)
                            }
                            .padding(.top, 8)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Theme.accentColor.opacity(0.3))
                        )
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 4)
                        .padding(.horizontal)
                    }
                    .transition(.scale)
                } else if showNoDiscMessage {
                    // Show error message only if the button is pressed and no disc is found
                    Text("No suitable disc found for the given criteria.")
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .transition(.opacity)
                }
                
                Spacer()
            }
            .padding()
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text("Invalid Input"),
                message: Text("Please select a stability and distance."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func getRecommendation() {
        let stability = stabilityOptions[selectedStabilityIndex]
        let distance = distanceOptions[selectedDistanceIndex]
        
        // Attempting recommendation
        recommendedDisc = discCatalogViewModel.recommendDisc(stability: stability, distance: distance)
        
        // Set showNoDiscMessage to true only if no disc is found
        showNoDiscMessage = recommendedDisc == nil
    }
}

// A small view component for displaying flight numbers in a neat way
struct FlightNumberView: View {
    var label: String
    var value: Double
    
    var body: some View {
        VStack {
            Text(label)
                .font(.caption)
                .foregroundColor(Theme.secondaryTextColor)
            Text("\(value, specifier: "%.1f")")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(Theme.primaryTextColor)
        }
    }
}
