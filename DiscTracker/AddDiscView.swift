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
                Section(header: Text("Disc Info")) {
                    TextField("Name", text: $name)
                    TextField("Type", text: $type)
                    TextField("Plastic Type", text: $plasticType)
                    TextField("Condition", text: $condition)
                }

                Section(header: Text("Image")) {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    } else {
                        Button("Select Image") {
                            showImagePicker = true
                        }
                    }
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(selectedImage: $selectedImage)
                }

                Button("Add Disc") {
                    // Save the image as Data
                    let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
                    let newDisc = Disc(name: name, type: type, plasticType: plasticType, condition: condition, imageData: imageData)
                    viewModel.discs.append(newDisc)
                    viewModel.saveDiscs()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Add Disc")
        }
    }
}
