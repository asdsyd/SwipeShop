//
//  OfflineProductManager.swift
//  SwipeShop
//
//  Created by Asad Sayeed on 11/02/25.
//

import Foundation

class OfflineProductManager {
    static let shared = OfflineProductManager()
    private let offlineKey = "offlineProducts"
    
    /// Retrieve saved offline products.
    func getOfflineProducts() -> [OfflineProduct] {
        if let data = UserDefaults.standard.data(forKey: offlineKey) {
            let decoder = JSONDecoder()
            if let products = try? decoder.decode([OfflineProduct].self, from: data) {
                return products
            }
        }
        return []
    }
    
    /// Save a new offline product.
    func saveOfflineProduct(_ product: OfflineProduct) {
        var products = getOfflineProducts()
        products.append(product)
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(products) {
            UserDefaults.standard.set(data, forKey: offlineKey)
        }
    }
    
    /// Remove an offline product with the given ID.
    func removeOfflineProduct(withId id: UUID) {
        var products = getOfflineProducts()
        products.removeAll { $0.id == id }
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(products) {
            UserDefaults.standard.set(data, forKey: offlineKey)
        }
    }
    
    /// Attempt to sync all offline products with the server.
    func syncOfflineProducts() {
        let products = getOfflineProducts()
        for product in products {
            submitOfflineProduct(product)
        }
    }
    
    /// Submit an offline product using the same API as for online submission.
    private func submitOfflineProduct(_ product: OfflineProduct) {
        guard let url = URL(string: "https://app.getswipe.in/api/public/add") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        // Append product name
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"product_name\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(product.productName)\r\n".data(using: .utf8)!)
        
        // Append product type
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"product_type\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(product.productType)\r\n".data(using: .utf8)!)
        
        // Append price
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"price\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(product.price)\r\n".data(using: .utf8)!)
        
        // Append tax
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"tax\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(product.tax)\r\n".data(using: .utf8)!)
        
        // Append image if available
        if let imageBase64 = product.imageBase64,
           let imageData = Data(base64Encoded: imageBase64) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"files[]\"; filename=\"product.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // If submission is successful, remove the offline product.
            if let data = data,
               let responseDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let success = responseDict["success"] as? Bool, success == true {
                self.removeOfflineProduct(withId: product.id)
            }
        }.resume()
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

