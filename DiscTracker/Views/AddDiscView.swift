import SwiftUI

struct AddDiscView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: DiscCatalogViewModel

    @State private var name: String = ""
    @State private var type: String = ""
    @State private var plasticType: String = ""
    @State private var condition: String = ""
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Disc Info").foregroundColor(.accentColor)) {
                    TextField("Manufacture", text: $name)
                        .padding(5)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)

                    TextField("Model", text: $type)
                        .padding(5)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)

                    TextField("Plastic Type", text: $plasticType)
                        .padding(5)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)

                    TextField("Condition", text: $condition)
                        .padding(5)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                }

                Section(header: Text("Image").foregroundColor(.accentColor)) {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .cornerRadius(8)
                            .shadow(radius: 5)
                    } else {
                        Button(action: { showImagePicker = true }) {
                            HStack {
                                Image(systemName: "photo.on.rectangle")
                                Text("Select Image")
                            }
                            .foregroundColor(.accentColor)
                            .padding()
                        }
                    }
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(selectedImage: $selectedImage)
                }

                Button(action: addDisc) {
                    Text("Add Disc")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .navigationTitle("Add Disc")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func addDisc() {
        let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
        let newDisc = Disc(name: name, type: type, plasticType: plasticType, condition: condition, imageData: imageData)
        viewModel.discs.append(newDisc)
        viewModel.saveDiscs()
        presentationMode.wrappedValue.dismiss()
    }
}
