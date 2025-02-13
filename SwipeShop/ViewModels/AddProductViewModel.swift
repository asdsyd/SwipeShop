//
//  AddProductViewModel.swift
//  SwipeShop
//
//  Created by Asad Sayeed on 31/01/25.
//

import SwiftUI
import PhotosUI
import Combine
import UIKit

class AddProductViewModel: ObservableObject {
    // Product details
    @Published var productName: String = ""
    @Published var productType: String = ""
    @Published var price: String = ""
    @Published var tax: String = ""
    
    // Image selection
    @Published var selectedPhotoItem: PhotosPickerItem? = nil
    @Published var selectedImage: UIImage? = nil
    @Published var imagePreview: Image? = nil
    
    // UI state
    @Published var isSubmitting: Bool = false
    @Published var alertMessage: String = ""
    @Published var alertTitle: String = ""
    @Published var showAlert: Bool = false
    
    let productTypes = ["Electronics", "Clothing", "Books", "Accessories"]
    private let apiURL = "https://app.getswipe.in/api/public/add"
    
    var isFormValid: Bool {
        !productName.isEmpty &&
        !productType.isEmpty &&
        Double(price) != nil &&
        Double(tax) != nil
    }
    
    /// Load image from the selected PhotosPickerItem.
    func loadImage(from item: PhotosPickerItem?) {
        guard let item = item else { return }
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                // Crop the image to a square. If cropping fails, fall back to the original image.
                let squareImage = uiImage.croppedToSquare() ?? uiImage
                await MainActor.run {
                    self.selectedImage = squareImage
                    self.imagePreview = Image(uiImage: squareImage)
                }
            }
        }
    }

    
    /// Save the product offline.
    private func saveOfflineProduct() {
        let imageBase64: String? = {
            if let image = selectedImage,
               let imageData = image.jpegData(compressionQuality: 0.8) {
                return imageData.base64EncodedString()
            }
            return nil
        }()
        
        let offlineProduct = OfflineProduct(
            id: UUID(),
            productName: productName,
            productType: productType,
            price: price,
            tax: tax,
            imageBase64: imageBase64
        )
        
        OfflineProductManager.shared.saveOfflineProduct(offlineProduct)
    }
    
    /// Submit the product. If offline, save it locally; if online, send it to the API.
    func submitProduct() {
        guard isFormValid else {
            alertTitle = "Validation Error"
            alertMessage = "Please fill in the details correctly."
            showAlert = true
            return
        }
        
        // Check for internet connectivity using the network monitor.
        if !NetworkMonitor.shared.isConnected {
            // Save product offline.
            saveOfflineProduct()
            alertTitle = "Offline Mode"
            alertMessage = "Product saved locally. It will be submitted once an internet connection is available."
            showAlert = true
            return
        }
        
        // Online submission path.
        isSubmitting = true
        guard let url = URL(string: apiURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"product_name\"\r\n\r\n")
        body.append("\(productName)\r\n")
        
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"product_type\"\r\n\r\n")
        body.append("\(productType)\r\n")
        
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"price\"\r\n\r\n")
        body.append("\(price)\r\n")
        
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"tax\"\r\n\r\n")
        body.append("\(tax)\r\n")
        
        if let image = selectedImage, let imageData = image.jpegData(compressionQuality: 0.8) {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"files[]\"; filename=\"product.jpg\"\r\n")
            body.append("Content-Type: image/jpeg\r\n\r\n")
            body.append(imageData)
            body.append("\r\n")
        }
        
        body.append("--\(boundary)--\r\n")
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isSubmitting = false
                if let data = data {
                    do {
                        let responseDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        if responseDict?["success"] as? Bool == true {
                            self.alertTitle = "Success"
                            self.alertMessage = "Product added successfully!"
                        } else {
                            self.alertTitle = "Error"
                            self.alertMessage = "Failed to add product"
                        }
                    } catch {
                        self.alertTitle = "Error"
                        self.alertMessage = "Error processing response."
                    }
                } else {
                    self.alertTitle = "Network Error"
                    self.alertMessage = "Please try again later."
                }
                self.showAlert = true
            }
        }.resume()
    }
}

extension UIImage {
    /// Crops the image to a square (1:1 ratio) using the smaller dimension,
    /// centering the crop area in the original image.
    func croppedToSquare() -> UIImage? {
        let originalWidth = size.width
        let originalHeight = size.height
        let squareLength = min(originalWidth, originalHeight)
        let xOffset = (originalWidth - squareLength) / 2.0
        let yOffset = (originalHeight - squareLength) / 2.0
        let cropRect = CGRect(x: xOffset, y: yOffset, width: squareLength, height: squareLength)
        
        guard let cgImage = self.cgImage?.cropping(to: cropRect) else { return nil }
        return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
    }
}

