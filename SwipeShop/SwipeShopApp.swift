//
//  SwipeShopApp.swift
//  SwipeShop
//
//  Created by Asad Sayeed on 31/01/25.
//

import SwiftUI

@main
struct SwipeShopApp: App {
    @State private var isActive = false
    
    var body: some Scene {
        WindowGroup {
            if isActive {
                ProductListView()
            } else {
                LaunchScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isActive = true
                            }
                        }
                    }
            }
        }
    }
}
