//
//  AddProductView.swift
//  SwipeShop
//
//  Created by Asad Sayeed on 31/01/25.
//

import SwiftUI
import PhotosUI

struct AddProductView: View {
    @StateObject private var viewModel = AddProductViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Product Details")) {
                    TextField("Product Name:", text: $viewModel.productName)
                        .textInputAutocapitalization(.words)
                    
                    Picker("Product Type", selection: $viewModel.productType) {
                        ForEach(viewModel.productTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    
                    TextField("Selling Price", text: $viewModel.price)
                        .keyboardType(.decimalPad)
                    
                    TextField("Tax Rate", text: $viewModel.tax)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Product Image (Optional)")) {
                    PhotosPicker("Select Image", selection: $viewModel.selectedPhotoItem, matching: .images)
                        .onChange(of: viewModel.selectedPhotoItem) { newItem in
                            viewModel.loadImage(from: newItem)
                        }
                    
                    if let image = viewModel.imagePreview {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                
                Section {
                    Button("Add Product") {
                        viewModel.submitProduct()
                    }
                    .disabled(!viewModel.isFormValid)
                }
            }
            .navigationTitle("Add Product")
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text(viewModel.alertTitle),
                      message: Text(viewModel.alertMessage),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    AddProductView()
}
