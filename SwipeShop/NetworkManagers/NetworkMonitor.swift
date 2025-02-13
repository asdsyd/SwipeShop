//
//  NetworkMonitor.swift
//  SwipeShop
//
//  Created by Asad Sayeed on 11/02/25.
//

import Network
import Combine

/// A singleton to monitor network connectivity.
class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()
    
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    
    @Published var isConnected: Bool = true
    
    private init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                let wasConnected = self.isConnected
                self.isConnected = (path.status == .satisfied)
                if !wasConnected && self.isConnected {
                    // If connectivity is restored, attempt to sync offline products.
                    OfflineProductManager.shared.syncOfflineProducts()
                }
            }
        }
        monitor.start(queue: queue)
    }
}
