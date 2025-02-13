//
//  OfflineProduct.swift
//  SwipeShop
//
//  Created by Asad Sayeed on 11/02/25.
//

import Foundation

struct OfflineProduct: Codable, Identifiable {
    let id: UUID
    let productName: String
    let productType: String
    let price: String
    let tax: String
    let imageBase64: String?
}
