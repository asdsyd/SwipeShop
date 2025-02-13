//
//  ProductListViewModel.swift
//  SwipeShop
//
//  Created by Asad Sayeed on 31/01/25.
//

import Foundation
import SwiftUI

class ProductListViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    @Published var favoriteProducts: Set<UUID> = []
    
    private let apiURL = "https://app.getswipe.in/api/public/get"
    
    func fetchProducts() {
        isLoading = true
        guard let url = URL(string: apiURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let data = data {
                    do {
                        let decodedProducts = try JSONDecoder().decode([Product].self, from: data)
                        self.products = decodedProducts
                    } catch {
                        print("Error decoding: \(error)")
                    }
                }
            }
        }
        .resume()
    }
    
    var filteredProducts: [Product] {
        
        let sortedProducts = products.sorted {
            
            (favoriteProducts.contains($0.id) ? 0 : 1) <
                (favoriteProducts.contains($1.id) ? 0 : 1)
        }
        
        if searchText.isEmpty {
            return sortedProducts
        } else {
            return sortedProducts.filter {
                $0.productName.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    func toggleFavorite(product: Product) {
        if favoriteProducts.contains(product.id) {
            favoriteProducts.remove(product.id)
        } else {
            favoriteProducts.insert(product.id)
        }
    }
}


