//
//  LaunchScreenView.swift
//  SwipeShop
//
//  Created by Asad Sayeed on 11/02/25.
//

import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        VStack {
            Spacer()
            Image(.swipeShopLaunchScreen) // Ensure the asset name matches exactly.
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
            Text("Swipe Shop")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black) // Force text to be black for contrast.
                .padding(.top, 20)
            Spacer()
        }
        // Use the color #EEF0FF: Red: 238, Green: 240, Blue: 255
        .background(Color(red: 238/255, green: 240/255, blue: 255/255))
        .ignoresSafeArea()
    }
}

#Preview {
    LaunchScreenView()
}
