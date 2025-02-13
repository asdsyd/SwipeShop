//
//  ProductListView.swift
//  SwipeShop
//
//  Created by Asad Sayeed on 31/01/25.
//

import SwiftUI

struct ProductListView: View {
    @StateObject private var viewModel = ProductListViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading products...")
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    productList
                }
            }
            .navigationTitle("Product List")
            .searchable(text: $viewModel.searchText, prompt: "Search products...")
            .onAppear {
                viewModel.fetchProducts()
            }
            .toolbar {
                NavigationLink(destination: AddProductView()) {
                    Label("Add Prodduct", systemImage: "plus.app")
                }
            }
        }
    }
    
    @ViewBuilder
    private var productList: some View {
        if viewModel.filteredProducts.isEmpty {
            ContentUnavailableView.search(text: viewModel.searchText)
        } else {
            List(viewModel.filteredProducts) { product in
                ProductRow(product: product, viewModel: viewModel)
            }
            .animation(.default, value: viewModel.filteredProducts)
        }
    }
}


struct ProductRow: View {
    let product: Product
    @ObservedObject var viewModel: ProductListViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            productImage
            
            VStack(alignment: .leading, spacing: 8) {
                Text(product.productName)
                    .font(.headline)
                
                Text(product.productType)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                
                HStack {
                    Text("₹\(String(format: "%.2f", product.price))")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("₹\(String(format: "%.2f", product.tax))")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
            
            Spacer()
            
            Button {
                viewModel.toggleFavorite(product: product)
            } label: {
                Image(systemName: viewModel.favoriteProducts.contains(product.id) ? "heart.fill" : "heart")
                    .foregroundStyle(viewModel.favoriteProducts.contains(product.id) ? .red : .gray)
            }
            .buttonStyle(PlainButtonStyle())

        }
        .padding(.vertical, 8)
    }
    
    @ViewBuilder
    private var productImage: some View {
        if let imageURL = product.image, let url = URL(string: imageURL) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 100, height: 100)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                case .failure:
                    imagePlaceholder
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            imagePlaceholder
        }
    }
    
    private var imagePlaceholder: some View {
        Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .foregroundStyle(.secondary)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    ProductListView()
}

