import SwiftUI

/// A custom text field with modern styling.
struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String

    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }

    var body: some View {
        TextField(placeholder, text: $text)
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
            )
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            .foregroundColor(.black)
    }
}

import SwiftUI

struct AddDiscView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var discCatalogViewModel: DiscCatalogViewModel
    @Binding var showAlert: Bool

    @State private var name: String = ""
    @State private var type: String = ""
    @State private var plasticType: String = ""
    @State private var selectedCondition: String = "New"

    // Predefined conditions
    let conditions = ["New", "Barely Thrown", "Good", "Worn", "Beat"]

    var body: some View {
        ZStack {
            // Green background
            Theme.backgroundColor
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                // Header
                Text("Add a New Disc")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.primaryTextColor)
                    .padding(.top, 40)

                // Input Fields
                VStack(spacing: 16) {
                    CustomTextField("Manufacture", text: $name)
                    CustomTextField("Model", text: $type)
                    CustomTextField("Plastic Type", text: $plasticType)

                    // Condition Dropdown
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Condition")
                            .font(.headline)
                            .foregroundColor(Theme.primaryTextColor)

                        Picker("Select Condition", selection: $selectedCondition) {
                            ForEach(conditions, id: \.self) { condition in
                                Text(condition).tag(condition)
                            }
                        }
                        .pickerStyle(MenuPickerStyle()) // Dropdown-style picker
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                        )
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                }
                .padding(.horizontal)

                Spacer()

                // Buttons
                VStack(spacing: 10) {
                    Button(action: saveDisc) {
                        Text("Save Disc")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(name.isEmpty || type.isEmpty || plasticType.isEmpty ? Color.gray : Theme.highlightColor)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 4)
                    }
                    .disabled(name.isEmpty || type.isEmpty || plasticType.isEmpty)

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
        discCatalogViewModel.addDisc(name: name, type: type, plasticType: plasticType, condition: selectedCondition)
        showAlert = true
        presentationMode.wrappedValue.dismiss()
    }
}
