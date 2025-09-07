//
//  NetworkMonitor.swift
//  ColorSyncro
//
//  Created by Aryan Pradhan on 01/08/25.
//

// NetworkMonitor.swift
import Foundation
import Network

extension Notification.Name {
    static let NetworkStatusDidChange = Notification.Name("NetworkStatusDidChange")
}

final class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")

    private(set) var isConnected: Bool = false

    private init() {
        monitor = NWPathMonitor() // Or NWPathMonitor(requiredInterfaceType: .wifi) if you only care about Wi-Fi
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            let newStatus = (path.status == .satisfied)

            // Only emit when status actually changes
            if newStatus != self.isConnected {
                self.isConnected = newStatus
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .NetworkStatusDidChange, object: self.isConnected)
                    print("📡 Network status: \(self.isConnected ? "Online" : "Offline")")
                }
            }
        }
        monitor.start(queue: queue)
    }
}
