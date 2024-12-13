//
//  AddDiscView.swift
//  DiscTracker
//
//  Created by Asher Antrim
//  Modified by OpenAI on 12/09/24.
//

import SwiftUI

struct AddDiscView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var discCatalogViewModel: DiscCatalogViewModel
    @Binding var showAlert: Bool

    @State private var name: String = ""
    @State private var type: String = ""
    @State private var plasticType: String = ""
    @State private var selectedCondition: String = "New"
    @State private var speedText: String = ""
    @State private var glideText: String = ""
    @State private var turnText: String = ""
    @State private var fadeText: String = ""

    let conditions = ["New", "Barely Thrown", "Good", "Worn", "Beat"]

    var body: some View {
        ZStack {
            Theme.backgroundColor.edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("Add a New Disc")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    // Ensure primary text color for adaptability
                    .foregroundColor(Theme.primaryTextColor)
                    .padding(.top, 40)

                VStack(spacing: 16) {
                    CustomTextField("Manufacture", text: $name)
                    CustomTextField("Model", text: $type)
                    CustomTextField("Plastic Type", text: $plasticType)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Condition")
                            .font(.headline)
                            .foregroundColor(Theme.primaryTextColor)

                        Picker("Select Condition", selection: $selectedCondition) {
                            ForEach(conditions, id: \.self) { condition in
                                Text(condition)
                                    .foregroundColor(Theme.primaryTextColor)
                                    .tag(condition)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(UIColor.secondarySystemBackground))
                        )
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }

                    Group {
                        CustomTextField("Speed", text: $speedText).keyboardType(.decimalPad)
                        CustomTextField("Glide", text: $glideText).keyboardType(.decimalPad)
                        CustomTextField("Turn", text: $turnText).keyboardType(.decimalPad)
                        CustomTextField("Fade", text: $fadeText).keyboardType(.decimalPad)
                    }
                }
                .padding(.horizontal)

                Spacer()

                VStack(spacing: 10) {
                    Button(action: saveDisc) {
                        Text("Save Disc")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                (name.isEmpty || type.isEmpty || plasticType.isEmpty ||
                                 speedText.isEmpty || glideText.isEmpty || turnText.isEmpty || fadeText.isEmpty)
                                ? Color.gray
                                : Theme.highlightColor
                            )
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 4)
                    }
                    .disabled(name.isEmpty || type.isEmpty || plasticType.isEmpty ||
                              speedText.isEmpty || glideText.isEmpty || turnText.isEmpty || fadeText.isEmpty)

                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Text("Cancel")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Theme.accentColor)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 4)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .padding()
        }
    }

    private func saveDisc() {
        guard let speed = Double(speedText),
              let glide = Double(glideText),
              let turn = Double(turnText),
              let fade = Double(fadeText) else {
            return
        }
        discCatalogViewModel.addDisc(
            name: name,
            type: type,
            plasticType: plasticType,
            condition: selectedCondition,
            speed: speed,
            glide: glide,
            turn: turn,
            fade: fade
        )
        showAlert = true
        presentationMode.wrappedValue.dismiss()
    }
}
