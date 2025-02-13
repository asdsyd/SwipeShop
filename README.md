# Swipe Shop
![946shots_so](https://github.com/user-attachments/assets/567daa50-07ff-41c6-8282-c4b3e215ae0d)
Swipe Shop is a fully functional iOS app built with SwiftUI that lets users view, search, and add products. It features offline functionality so that any products created while offline are saved locally and automatically synchronized when an internet connection becomes available.

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation & Build Instructions](#installation--build-instructions)
- [App Architecture](#app-architecture)
- [Usage](#usage)
- [Offline Functionality](#offline-functionality)
- [Assets](#assets)

## Features

- **Product Listing:** View a list of products with search and scroll capabilities.
- **Product Details:** Each product displays an image (loaded from a URL or a default placeholder), name, type, price, and tax.
- **Favorites:** Mark products as favorites. Favorited products appear at the top.
- **Add Product Screen:** Enter product details including name, type, selling price, and tax rate. Optionally select an image (JPEG or PNG) that is cropped to a 1:1 ratio automatically.
- **Offline Support:** If no internet connection is available when adding a product, the product is saved locally and automatically synchronized once connectivity is restored.
- **Launch Screen:** A custom launch screen displays an image and the text "Swipe Shop" when the app starts.
- **Network Monitoring:** Uses Apple's Network framework (`NWPathMonitor`) to detect internet connectivity.

## Prerequisites

- **Xcode:** Version 14 or later (to support Swift concurrency and the latest SwiftUI features).
- **iOS Deployment Target:** iOS 15.0 or later.
- **Swift:** 5.5 or later.

## Installation & Build Instructions

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/yourusername/SwipeShop.git
   cd SwipeShop
   ```

2. **Open the Project:**

   Open `SwipeShop.xcodeproj` (or `.xcworkspace` if using Swift Package Manager or CocoaPods) in Xcode.

3. **Configure Assets:**

   - Add the launch screen image (`swipe-launch-screen.jpg`) into the Xcode Assets catalog. Ensure the asset name is exactly **`swipe-launch-screen`**.
   - If using custom colors (e.g., `BackgroundStart`, `BackgroundEnd`), add them to your Assets as well or modify the code to use standard colors.

4. **Build & Run:**

   - Select a simulator or a connected device.
   - Press **Cmd+R** to build and run the app.

## App Architecture

Swipe Shop is built using the **MVVM (Model-View-ViewModel)** architecture:

- **Models:**
  - `Product`: Represents a product with properties like product name, type, price, tax, and image URL.
  - `OfflineProduct`: A lightweight model for saving products locally when offline.

- **ViewModels:**
  - `ProductListViewModel`: Manages fetching, searching, and displaying products. It also handles marking products as favorites.
  - `AddProductViewModel`: Manages the state for adding a product including form validation, image selection & cropping, API submission, and offline saving.

- **Views:**
  - `ProductListView`: Displays the list of products, includes search functionality, and navigates to the Add Product screen.
  - `AddProductView`: Allows users to input product details, pick an image (with cropping to a 1:1 ratio), and submit the product.
  - `LaunchScreenView`: A custom splash screen displayed at launch.

- **Offline & Network Support:**
  - `OfflineProductManager`: Handles local storage (using UserDefaults) and synchronizes offline products when connectivity is restored.
  - `NetworkMonitor`: Uses `NWPathMonitor` to observe connectivity changes and triggers sync operations.

## Usage

- **Product List:**
  - On launch, the app displays a splash screen with your custom image and “Swipe Shop” text.
  - Once loaded, you can browse the product list. Use the search bar to filter products.
  - Tap the favorite icon to mark/unmark a product as favorite.

- **Add Product:**
  - Navigate to the Add Product screen using the toolbar button.
  - Enter product details, choose the product type from the picker, and fill in the price and tax rate.
  - Tap on the "Select Image" button to choose an image. The selected image will automatically be cropped to a square.
  - Tap the "Add Product" button to submit. If offline, the product is stored locally and synchronized when connectivity is restored.

## Offline Functionality

- If the app detects no internet connection when a product is added:
  - The product details (including an optionally cropped image encoded in Base64) are saved locally using UserDefaults.
  - When the device regains connectivity, the `NetworkMonitor` triggers a sync process that submits the offline products to the API.

## Assets

- **swipe-launch-screen.jpg:** This image is used in the launch screen. Ensure it is added to the Assets catalog with the name `swipe-launch-screen`.
- **Color Assets:** If you have custom color assets for backgrounds or other UI elements (e.g., `BackgroundStart`, `BackgroundEnd`), make sure to add them or update the code to use standard colors.




 
