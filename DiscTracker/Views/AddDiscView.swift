import SwiftUI

/// View for adding a new disc to the catalog.
struct AddDiscView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var discCatalogViewModel: DiscCatalogViewModel
    @Binding var showAlert : Bool
    
    @State private var name: String = ""
    @State private var type: String = ""
    @State private var plasticType: String = ""
    @State private var condition: String = ""
    @State private var imageData: Data?

    /// Custom initializer to inject the view model.
    init(viewModel: DiscCatalogViewModel, showAlert: Binding<Bool>) {
        self.discCatalogViewModel = viewModel
        self._showAlert = showAlert
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Disc Information")) {
                    TextField("Name", text: $name)
                    TextField("Type", text: $type)
                    TextField("Plastic Type", text: $plasticType)
                    TextField("Condition", text: $condition)
                }
            }
            .navigationBarTitle("Add New Disc", displayMode: .inline)
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
        }
    }

    /// The cancel button to dismiss the view without saving.
    private var cancelButton: some View {
        Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        }
    }

    /// The save button to add the new disc to the catalog.
    private var saveButton: some View {
        Button("Save") {
            discCatalogViewModel.addDisc(name: name, type: type, plasticType: plasticType, condition: condition, imageData: imageData)
            // will add points here for reward
            showAlert = true
            presentationMode.wrappedValue.dismiss()
        }
        .disabled(name.isEmpty || type.isEmpty || plasticType.isEmpty || condition.isEmpty)
    }
}

#Preview {
    AddDiscView(viewModel: DiscCatalogViewModel(), showAlert: .constant(true))
}
