//
//  Product.swift
//  SwipeShop
//
//  Created by Asad Sayeed on 31/01/25.
//

import SwiftUI

struct Product: Identifiable, Codable, Equatable {
    let id = UUID()
    let image: String?
    let productName: String
    let productType: String
    let price: Double
    let tax: Double
    
    enum CodingKeys: String, CodingKey {
        case image, price, tax
        case productName = "product_name"
        case productType = "product_type"
    }
}
