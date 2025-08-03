//
//  NetworkMonitor.swift
//  ColorSyncro
//
//  Created by Aryan Pradhan on 01/08/25.
//

import Foundation
import Network

class NetworkMonitor: ObservableObject {
    let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    @Published var isConnected: Bool = true
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
                print("📡 Network status changed: \(self?.isConnected == true ? "Online" : "Offline")")
            }
        }
        monitor.start(queue: queue)
    }
}
