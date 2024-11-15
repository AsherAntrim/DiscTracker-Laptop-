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

                Section {
                    VStack(spacing: 8) {
                            if let selectedImage = selectedImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                            } else {
                                ZStack {
                                    Circle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 100, height: 100)
                                    Image(systemName: "camera.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.blue)
                                }
                        }
                        Text("Add Photo")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    .frame(maxWidth: .infinity)
                }
                .listRowBackground(Color.clear)

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
